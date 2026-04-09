package com.jeju.jeju.infrastructure.tourapi;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.mock;

@ExtendWith(MockitoExtension.class)
class TourApiClientTest {

    @InjectMocks
    private TourApiClient tourApiClient;

    private RestTemplate restTemplate;

    @BeforeEach
    void setUp() {
        restTemplate = mock(RestTemplate.class);
        ReflectionTestUtils.setField(tourApiClient, "restTemplate", restTemplate);
        ReflectionTestUtils.setField(tourApiClient, "korServiceKey", "test-kor-key");
        ReflectionTestUtils.setField(tourApiClient, "korWithServiceKey", "test-with-key");
        ReflectionTestUtils.setField(tourApiClient, "baseUrl", "https://apis.data.go.kr/B551011");
    }

    // ── fetchTourPlaces ────────────────────────────────────────────

    @Test
    @DisplayName("정상 응답 시 TourApiPlaceDto 목록 반환")
    void fetchTourPlaces_validResponse_returnsDtoList() {
        // given
        Map<String, Object> response = buildPlaceResponse(
                Map.of("contentid", "126508", "title", "성산일출봉",
                        "addr1", "제주특별자치도 서귀포시", "mapx", "126.9425229",
                        "mapy", "33.4589707", "contenttypeid", "12",
                        "firstimage", "http://example.com/img.jpg", "tel", "064-783-0959")
        );
        given(restTemplate.getForObject(anyString(), eq(Map.class))).willReturn(response);

        // when
        List<TourApiPlaceDto> result = tourApiClient.fetchTourPlaces(1, 100);

        // then
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getContentid()).isEqualTo("126508");
        assertThat(result.get(0).getTitle()).isEqualTo("성산일출봉");
        assertThat(result.get(0).getContenttypeid()).isEqualTo("12");
        assertThat(result.get(0).getTel()).isEqualTo("064-783-0959");
    }

    @Test
    @DisplayName("빈 items 응답 시 빈 목록 반환")
    void fetchTourPlaces_emptyItems_returnsEmptyList() {
        // given
        Map<String, Object> response = Map.of(
                "response", Map.of(
                        "body", Map.of(
                                "items", Map.of()
                        )
                )
        );
        given(restTemplate.getForObject(anyString(), eq(Map.class))).willReturn(response);

        // when
        List<TourApiPlaceDto> result = tourApiClient.fetchTourPlaces(1, 100);

        // then
        assertThat(result).isEmpty();
    }

    @Test
    @DisplayName("단일 item(Map)인 경우 List.of(item)으로 처리")
    void fetchTourPlaces_singleItem_returnsListWithOneElement() {
        // given — item이 List가 아닌 단일 Map
        Map<String, Object> singleItem = Map.of(
                "contentid", "999", "title", "단일장소",
                "contenttypeid", "39"
        );
        Map<String, Object> response = Map.of(
                "response", Map.of(
                        "body", Map.of(
                                "items", Map.of("item", singleItem)
                        )
                )
        );
        given(restTemplate.getForObject(anyString(), eq(Map.class))).willReturn(response);

        // when
        List<TourApiPlaceDto> result = tourApiClient.fetchTourPlaces(1, 100);

        // then
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getContentid()).isEqualTo("999");
    }

    @Test
    @DisplayName("RestClientException 발생 시 PLACE_002 예외")
    void fetchTourPlaces_restClientException_throwsPlace002() {
        // given
        given(restTemplate.getForObject(anyString(), eq(Map.class)))
                .willThrow(new RestClientException("연결 실패"));

        // when / then
        assertThatThrownBy(() -> tourApiClient.fetchTourPlaces(1, 100))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.PLACE_002);
    }

    // ── fetchTotalCount ────────────────────────────────────────────

    @Test
    @DisplayName("totalCount 정상 파싱")
    void fetchTotalCount_validResponse_returnsCount() {
        // given
        Map<String, Object> response = Map.of(
                "response", Map.of(
                        "body", Map.of("totalCount", 500)
                )
        );
        given(restTemplate.getForObject(anyString(), eq(Map.class))).willReturn(response);

        // when
        int result = tourApiClient.fetchTotalCount();

        // then
        assertThat(result).isEqualTo(500);
    }

    @Test
    @DisplayName("null 응답 시 0 반환")
    void fetchTotalCount_nullResponse_returnsZero() {
        // given
        given(restTemplate.getForObject(anyString(), eq(Map.class))).willReturn(null);

        // when
        int result = tourApiClient.fetchTotalCount();

        // then
        assertThat(result).isZero();
    }

    @Test
    @DisplayName("예외 발생 시 0 반환 (배치 중단 방지)")
    void fetchTotalCount_exception_returnsZero() {
        // given
        given(restTemplate.getForObject(anyString(), eq(Map.class)))
                .willThrow(new RestClientException("오류"));

        // when
        int result = tourApiClient.fetchTotalCount();

        // then
        assertThat(result).isZero();
    }

    // ── fetchImages ────────────────────────────────────────────────

    @Test
    @DisplayName("이미지 URL 목록 정상 파싱")
    void fetchImages_validResponse_returnsUrlList() {
        // given
        Map<String, Object> response = Map.of(
                "response", Map.of(
                        "body", Map.of(
                                "items", Map.of(
                                        "item", List.of(
                                                Map.of("originimgurl", "http://example.com/img1.jpg"),
                                                Map.of("originimgurl", "http://example.com/img2.jpg")
                                        )
                                )
                        )
                )
        );
        given(restTemplate.getForObject(anyString(), eq(Map.class))).willReturn(response);

        // when
        List<String> result = tourApiClient.fetchImages("126508");

        // then
        assertThat(result).hasSize(2);
        assertThat(result.get(0)).isEqualTo("http://example.com/img1.jpg");
    }

    @Test
    @DisplayName("이미지 조회 실패 시 빈 목록 반환")
    void fetchImages_exception_returnsEmptyList() {
        // given
        given(restTemplate.getForObject(anyString(), eq(Map.class)))
                .willThrow(new RestClientException("오류"));

        // when
        List<String> result = tourApiClient.fetchImages("126508");

        // then
        assertThat(result).isEmpty();
    }

    // ── fetchBarrierFreeInfo ───────────────────────────────────────

    @Test
    @DisplayName("무장애 정보 정상 파싱")
    void fetchBarrierFreeInfo_validResponse_returnsDtoList() {
        // given
        Map<String, Object> response = buildPlaceResponse(
                Map.of("contentid", "126508", "wheelchair", "1",
                        "elevator", "0", "restroom", "1",
                        "route", "0", "parking", "1")
        );
        given(restTemplate.getForObject(anyString(), eq(Map.class))).willReturn(response);

        // when
        List<TourApiBarrierFreeDto> result = tourApiClient.fetchBarrierFreeInfo(1, 100);

        // then
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getContentid()).isEqualTo("126508");
        assertThat(result.get(0).getWheelchair()).isEqualTo("1");
        assertThat(result.get(0).getElevator()).isEqualTo("0");
        assertThat(result.get(0).getParking()).isEqualTo("1");
    }

    @Test
    @DisplayName("무장애 정보 조회 실패 시 빈 목록 반환 (배치 중단 방지)")
    void fetchBarrierFreeInfo_exception_returnsEmptyList() {
        // given
        given(restTemplate.getForObject(anyString(), eq(Map.class)))
                .willThrow(new RestClientException("오류"));

        // when
        List<TourApiBarrierFreeDto> result = tourApiClient.fetchBarrierFreeInfo(1, 100);

        // then
        assertThat(result).isEmpty();
    }

    // ── helpers ────────────────────────────────────────────────────

    private Map<String, Object> buildPlaceResponse(Map<String, Object> item) {
        return Map.of(
                "response", Map.of(
                        "body", Map.of(
                                "items", Map.of("item", List.of(item)),
                                "totalCount", 1,
                                "numOfRows", 100,
                                "pageNo", 1
                        )
                )
        );
    }
}

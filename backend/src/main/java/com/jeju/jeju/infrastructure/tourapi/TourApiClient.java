package com.jeju.jeju.infrastructure.tourapi;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Component
public class TourApiClient {

    private static final String BASE_URL = "http://apis.data.go.kr/B551011/KorService1";

    @Value("${tour.api.key:}")
    private String serviceKey;

    private final RestTemplate restTemplate;

    public TourApiClient() {
        this.restTemplate = new RestTemplate();
    }

    /**
     * 한국관광공사 OpenAPI에서 지역 기반 장소 목록을 조회합니다.
     *
     * @param areaCode  지역 코드 (예: "39" = 제주)
     * @param pageNo    페이지 번호 (1부터 시작)
     * @param numOfRows 페이지당 결과 수
     * @return 장소 DTO 목록
     * @throws BusinessException API 호출 실패 시 PLACE_002
     */
    @SuppressWarnings("unchecked")
    public List<TourApiPlaceDto> fetchPlaces(String areaCode, int pageNo, int numOfRows) {
        try {
            String url = UriComponentsBuilder.fromHttpUrl(BASE_URL + "/areaBasedList1")
                    .queryParam("serviceKey", serviceKey)
                    .queryParam("numOfRows", numOfRows)
                    .queryParam("pageNo", pageNo)
                    .queryParam("MobileOS", "ETC")
                    .queryParam("MobileApp", "JejuApp")
                    .queryParam("_type", "json")
                    .queryParam("areaCode", areaCode)
                    .build(false)
                    .toUriString();

            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            if (response == null) {
                return Collections.emptyList();
            }
            // TODO: 실제 API 응답 파싱 구현 (response.response.body.items.item)
            return Collections.emptyList();
        } catch (RestClientException e) {
            throw new BusinessException(ErrorCode.PLACE_002);
        }
    }
}

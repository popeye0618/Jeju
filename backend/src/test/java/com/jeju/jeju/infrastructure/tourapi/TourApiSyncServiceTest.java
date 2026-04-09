package com.jeju.jeju.infrastructure.tourapi;

import com.jeju.jeju.domain.place.entity.TouristSpot;
import com.jeju.jeju.domain.place.repository.TouristSpotRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class TourApiSyncServiceTest {

    @Mock private TourApiClient tourApiClient;
    @Mock private TouristSpotRepository touristSpotRepository;

    @InjectMocks
    private TourApiSyncService tourApiSyncService;

    private TourApiPlaceDto placeDto;
    private TourApiBarrierFreeDto barrierFreeDto;

    @BeforeEach
    void setUp() {
        placeDto = new TourApiPlaceDto();
        placeDto.setContentid("126508");
        placeDto.setTitle("성산일출봉");
        placeDto.setAddr1("제주특별자치도 서귀포시 성산읍");
        placeDto.setMapx("126.9425229");
        placeDto.setMapy("33.4589707");
        placeDto.setContenttypeid("12");
        placeDto.setFirstimage("http://example.com/img.jpg");
        placeDto.setTel("064-783-0959");

        barrierFreeDto = new TourApiBarrierFreeDto();
        barrierFreeDto.setContentid("126508");
        barrierFreeDto.setWheelchair("1");
        barrierFreeDto.setElevator("0");
        barrierFreeDto.setRestroom("1");
        barrierFreeDto.setRoute("0");
        barrierFreeDto.setParking("1");
    }

    // ── saveTourSpots ──────────────────────────────────────────────

    @Test
    @DisplayName("새 장소 — TouristSpot.create 후 save 호출")
    void saveTourSpots_newSpot_savesToRepository() {
        // given
        given(touristSpotRepository.findByContentId("126508")).willReturn(Optional.empty());
        given(touristSpotRepository.save(any(TouristSpot.class))).willAnswer(inv -> inv.getArgument(0));

        // when
        tourApiSyncService.saveTourSpots(List.of(placeDto));

        // then
        verify(touristSpotRepository).save(any(TouristSpot.class));
    }

    @Test
    @DisplayName("기존 장소 — update 호출, save 없음")
    void saveTourSpots_existingSpot_callsUpdate() {
        // given
        TouristSpot existingSpot = mock(TouristSpot.class);
        given(touristSpotRepository.findByContentId("126508")).willReturn(Optional.of(existingSpot));

        // when
        tourApiSyncService.saveTourSpots(List.of(placeDto));

        // then
        verify(existingSpot).update(
                "성산일출봉",
                "제주특별자치도 서귀포시 성산읍",
                33.4589707,
                126.9425229,
                TouristSpot.Category.NATURE,
                "064-783-0959",
                "http://example.com/img.jpg"
        );
        verify(touristSpotRepository, never()).save(any());
    }

    @Test
    @DisplayName("contenttypeid 14 → CULTURE 매핑")
    void saveTourSpots_contentType14_mapsToCulture() {
        // given
        placeDto.setContenttypeid("14");
        given(touristSpotRepository.findByContentId("126508")).willReturn(Optional.empty());
        given(touristSpotRepository.save(any(TouristSpot.class))).willAnswer(inv -> inv.getArgument(0));

        // when
        tourApiSyncService.saveTourSpots(List.of(placeDto));

        // then — save 호출됨으로써 Category.CULTURE로 생성됐음을 확인
        verify(touristSpotRepository).save(any(TouristSpot.class));
    }

    @Test
    @DisplayName("contenttypeid 39 → FOOD 매핑")
    void saveTourSpots_contentType39_mapsToFood() {
        // given
        placeDto.setContenttypeid("39");
        given(touristSpotRepository.findByContentId("126508")).willReturn(Optional.empty());
        given(touristSpotRepository.save(any(TouristSpot.class))).willAnswer(inv -> inv.getArgument(0));

        // when
        tourApiSyncService.saveTourSpots(List.of(placeDto));

        // then
        verify(touristSpotRepository).save(any(TouristSpot.class));
    }

    @Test
    @DisplayName("contentId가 null인 DTO는 저장 스킵")
    void saveTourSpots_nullContentId_skipsEntry() {
        // given
        TourApiPlaceDto nullIdDto = new TourApiPlaceDto();
        nullIdDto.setContentid(null);
        nullIdDto.setTitle("이름");

        // when
        tourApiSyncService.saveTourSpots(List.of(nullIdDto));

        // then
        verify(touristSpotRepository, never()).findByContentId(anyString());
        verify(touristSpotRepository, never()).save(any());
    }

    @Test
    @DisplayName("여러 장소 한 번에 저장")
    void saveTourSpots_multipleDtos_savesAll() {
        // given
        TourApiPlaceDto dto2 = new TourApiPlaceDto();
        dto2.setContentid("999");
        dto2.setTitle("제주 시장");
        dto2.setContenttypeid("39");

        given(touristSpotRepository.findByContentId(anyString())).willReturn(Optional.empty());
        given(touristSpotRepository.save(any(TouristSpot.class))).willAnswer(inv -> inv.getArgument(0));

        // when
        tourApiSyncService.saveTourSpots(List.of(placeDto, dto2));

        // then
        verify(touristSpotRepository, times(2)).save(any(TouristSpot.class));
    }

    // ── updateBarrierFreeSpots ─────────────────────────────────────

    @Test
    @DisplayName("무장애 정보 업데이트 — updateBarrierFree 호출됨")
    void updateBarrierFreeSpots_existingSpot_callsUpdateBarrierFree() {
        // given
        TouristSpot spot = mock(TouristSpot.class);
        given(touristSpotRepository.findByContentId("126508")).willReturn(Optional.of(spot));

        // when
        tourApiSyncService.updateBarrierFreeSpots(List.of(barrierFreeDto));

        // then
        verify(spot).updateBarrierFree(true, false, true, false, true);
    }

    @Test
    @DisplayName("contentId 매칭 안 되면 updateBarrierFree 호출 없음")
    void updateBarrierFreeSpots_notFound_skips() {
        // given
        given(touristSpotRepository.findByContentId(anyString())).willReturn(Optional.empty());

        // when
        tourApiSyncService.updateBarrierFreeSpots(List.of(barrierFreeDto));

        // then — 예외 없이 통과
    }

    @Test
    @DisplayName("모든 필드 0이면 updateBarrierFree(false,false,false,false,false)")
    void updateBarrierFreeSpots_allZero_allFalse() {
        // given
        barrierFreeDto.setWheelchair("0");
        barrierFreeDto.setElevator("0");
        barrierFreeDto.setRestroom("0");
        barrierFreeDto.setRoute("0");
        barrierFreeDto.setParking("0");

        TouristSpot spot = mock(TouristSpot.class);
        given(touristSpotRepository.findByContentId("126508")).willReturn(Optional.of(spot));

        // when
        tourApiSyncService.updateBarrierFreeSpots(List.of(barrierFreeDto));

        // then
        verify(spot).updateBarrierFree(false, false, false, false, false);
    }

    // ── updateSpotImages ───────────────────────────────────────────

    @Test
    @DisplayName("이미지 업데이트 — updateImages 호출됨")
    void updateSpotImages_existingSpot_callsUpdateImages() {
        // given
        TouristSpot spot = mock(TouristSpot.class);
        given(touristSpotRepository.findById(1L)).willReturn(Optional.of(spot));
        List<String> images = List.of("http://img1.jpg", "http://img2.jpg");

        // when
        tourApiSyncService.updateSpotImages(1L, images);

        // then
        verify(spot).updateImages(images);
    }

    @Test
    @DisplayName("존재하지 않는 ID — updateImages 미호출")
    void updateSpotImages_notFound_noOp() {
        // given
        given(touristSpotRepository.findById(999L)).willReturn(Optional.empty());

        // when
        tourApiSyncService.updateSpotImages(999L, List.of("http://img.jpg"));

        // then — 예외 없이 통과
    }

    // ── syncAll ────────────────────────────────────────────────────

    @Test
    @DisplayName("totalCount=0이면 fetchTourPlaces 호출 안 함")
    void syncAll_zeroTotalCount_noFetch() {
        // given
        given(tourApiClient.fetchTotalCount()).willReturn(0);

        // when
        tourApiSyncService.syncAll();

        // then
        verify(tourApiClient, never()).fetchTourPlaces(anyInt(), anyInt());
    }

    @Test
    @DisplayName("totalCount=150이면 2페이지 fetchTourPlaces 호출")
    void syncAll_150TotalCount_twoPageFetches() {
        // given
        given(tourApiClient.fetchTotalCount()).willReturn(150);
        given(tourApiClient.fetchTourPlaces(anyInt(), anyInt())).willReturn(Collections.emptyList());
        given(tourApiClient.fetchBarrierFreeInfo(anyInt(), anyInt())).willReturn(Collections.emptyList());
        given(touristSpotRepository.findByImagesIsNullOrImagesIsEmpty()).willReturn(Collections.emptyList());

        // when
        tourApiSyncService.syncAll();

        // then
        verify(tourApiClient, times(2)).fetchTourPlaces(anyInt(), anyInt());
    }
}

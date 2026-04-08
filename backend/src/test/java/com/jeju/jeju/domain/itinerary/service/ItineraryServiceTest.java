package com.jeju.jeju.domain.itinerary.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.common.response.PageResponse;
import com.jeju.jeju.domain.itinerary.dto.*;
import com.jeju.jeju.domain.itinerary.entity.*;
import com.jeju.jeju.domain.itinerary.entity.Itinerary.ItineraryType;
import com.jeju.jeju.domain.itinerary.repository.*;
import com.jeju.jeju.domain.place.entity.TouristSpot;
import com.jeju.jeju.domain.place.repository.TouristSpotRepository;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ItineraryServiceTest {

    @InjectMocks
    private ItineraryService itineraryService;

    @Mock private ItineraryRepository itineraryRepository;
    @Mock private RouteRepository routeRepository;
    @Mock private RoutePlaceRepository routePlaceRepository;
    @Mock private AlternativeRouteRepository alternativeRouteRepository;
    @Mock private UserItinerarySaveRepository userItinerarySaveRepository;
    @Mock private UserRepository userRepository;
    @Mock private TouristSpotRepository touristSpotRepository;

    // ── helpers ────────────────────────────────────────────────────────

    private User mockNormalUser() {
        User user = mock(User.class);
        given(user.getId()).willReturn(1L);
        given(user.getMobility()).willReturn(User.Mobility.NORMAL);
        return user;
    }

    private Itinerary mockCustomItinerary() {
        Itinerary it = mock(Itinerary.class);
        given(it.getId()).willReturn(10L);
        given(it.getTitle()).willReturn("테스트 일정");
        given(it.getThumbnail()).willReturn(null);
        given(it.getType()).willReturn(ItineraryType.CUSTOM);
        given(it.getAccessibilityScore()).willReturn(75);
        given(it.getTripDays()).willReturn(1);
        given(it.getRoutes()).willReturn(Collections.emptyList());
        given(it.isOwner(1L)).willReturn(true);
        given(it.isOwner(2L)).willReturn(false);
        return it;
    }

    private TouristSpot mockSpot() {
        TouristSpot spot = mock(TouristSpot.class);
        given(spot.getId()).willReturn(100L);
        given(spot.getName()).willReturn("한라산");
        given(spot.getLat()).willReturn(33.36);
        given(spot.getLng()).willReturn(126.53);
        given(spot.getAccessibilityScore()).willReturn(80);
        given(spot.isHasRamp()).willReturn(true);
        given(spot.isHasElevator()).willReturn(false);
        given(spot.isHasAccessibleToilet()).willReturn(true);
        given(spot.isHasRestZone()).willReturn(false);
        given(spot.isHasAccessibleParking()).willReturn(true);
        return spot;
    }

    // ── recommendItineraries ─────────────────────────────────────────

    @Test
    @DisplayName("추천 일정 조회 - 비로그인 시 빈 리스트 반환")
    void recommendItineraries_anonymousUser_returnsEmpty() {
        // given
        Page<Itinerary> emptyPage = new PageImpl<>(Collections.emptyList());
        given(itineraryRepository.findByTypeOrderByCreatedAtDesc(
                eq(ItineraryType.RECOMMENDED), any(Pageable.class)))
                .willReturn(emptyPage);

        // when
        PageResponse<ItinerarySummaryResponse> result =
                itineraryService.recommendItineraries(null, LocalDate.now());

        // then
        assertThat(result.getContent()).isEmpty();
    }

    @Test
    @DisplayName("추천 일정 조회 - WHEELCHAIR 사용자는 접근성 점수 80 이상만 필터")
    void recommendItineraries_wheelchairUser_filtersLowAccessibility() {
        // given
        Itinerary highScore = mock(Itinerary.class);
        given(highScore.getId()).willReturn(1L);
        given(highScore.getTitle()).willReturn("고접근성 일정");
        given(highScore.getThumbnail()).willReturn(null);
        given(highScore.getType()).willReturn(ItineraryType.RECOMMENDED);
        given(highScore.getAccessibilityScore()).willReturn(85);
        given(highScore.getRoutes()).willReturn(Collections.emptyList());

        Itinerary lowScore = mock(Itinerary.class);
        given(lowScore.getId()).willReturn(2L);
        given(lowScore.getAccessibilityScore()).willReturn(60);

        Page<Itinerary> page = new PageImpl<>(List.of(highScore, lowScore));
        given(itineraryRepository.findByTypeOrderByCreatedAtDesc(
                eq(ItineraryType.RECOMMENDED), any(Pageable.class)))
                .willReturn(page);

        User wheelchairUser = mock(User.class);
        given(wheelchairUser.getMobility()).willReturn(User.Mobility.WHEELCHAIR);
        given(userRepository.findById(1L)).willReturn(Optional.of(wheelchairUser));
        given(userItinerarySaveRepository.existsByUserIdAndItineraryId(anyLong(), anyLong()))
                .willReturn(false);

        // when
        PageResponse<ItinerarySummaryResponse> result =
                itineraryService.recommendItineraries(1L, LocalDate.now());

        // then
        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getAccessibilityScore()).isGreaterThanOrEqualTo(80);
    }

    // ── getMyItineraries ─────────────────────────────────────────────

    @Test
    @DisplayName("내 저장 일정 조회 - 정상 반환")
    void getMyItineraries_returnsPageResponse() {
        // given
        Itinerary itinerary = mockCustomItinerary();
        UserItinerarySave save = mock(UserItinerarySave.class);
        given(save.getItinerary()).willReturn(itinerary);
        given(save.getCreatedAt()).willReturn(null);

        Page<UserItinerarySave> savePage = new PageImpl<>(List.of(save));
        given(userItinerarySaveRepository.findByUserIdOrderByCreatedAtDesc(
                eq(1L), any(Pageable.class)))
                .willReturn(savePage);

        // when
        PageResponse<ItinerarySummaryResponse> result =
                itineraryService.getMyItineraries(1L, 0, 10);

        // then
        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getTitle()).isEqualTo("테스트 일정");
    }

    // ── createItinerary ──────────────────────────────────────────────

    @Test
    @DisplayName("일정 생성 - 정상 생성 후 Summary 반환")
    void createItinerary_validRequest_returnsSummary() {
        // given
        User user = mockNormalUser();
        TouristSpot spot = mockSpot();
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(touristSpotRepository.findById(100L)).willReturn(Optional.of(spot));

        Itinerary savedItinerary = mock(Itinerary.class);
        given(savedItinerary.getId()).willReturn(10L);
        given(savedItinerary.getTitle()).willReturn("새 일정");
        given(savedItinerary.getThumbnail()).willReturn(null);
        given(savedItinerary.getType()).willReturn(ItineraryType.CUSTOM);
        given(savedItinerary.getAccessibilityScore()).willReturn(80);
        given(savedItinerary.getRoutes()).willReturn(Collections.emptyList());
        given(itineraryRepository.save(any(Itinerary.class))).willReturn(savedItinerary);
        given(userItinerarySaveRepository.save(any(UserItinerarySave.class)))
                .willReturn(mock(UserItinerarySave.class));

        ItineraryCreateRequest req = new ItineraryCreateRequest(
                "새 일정", 1,
                List.of(new ItineraryPlaceRequest(100L, 1, 1)));

        // when
        ItinerarySummaryResponse response = itineraryService.createItinerary(1L, req);

        // then
        assertThat(response).isNotNull();
        assertThat(response.getTitle()).isEqualTo("새 일정");
        verify(itineraryRepository).save(any(Itinerary.class));
        verify(userItinerarySaveRepository).save(any(UserItinerarySave.class));
    }

    @Test
    @DisplayName("일정 생성 - 존재하지 않는 장소 요청 시 PLACE_001 예외")
    void createItinerary_invalidPlace_throwsPlaceNotFound() {
        // given
        User user = mockNormalUser();
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(touristSpotRepository.findById(999L)).willReturn(Optional.empty());

        ItineraryCreateRequest req = new ItineraryCreateRequest(
                "새 일정", 1,
                List.of(new ItineraryPlaceRequest(999L, 1, 1)));

        // when / then
        assertThatThrownBy(() -> itineraryService.createItinerary(1L, req))
                .isInstanceOf(BusinessException.class)
                .extracting("errorCode")
                .isEqualTo(ErrorCode.PLACE_001);
    }

    // ── getItineraryDetail ───────────────────────────────────────────

    @Test
    @DisplayName("일정 상세 조회 - 존재하지 않으면 ITIN_001 예외")
    void getItineraryDetail_notFound_throwsItin001() {
        // given
        given(itineraryRepository.findById(999L)).willReturn(Optional.empty());

        // when / then
        assertThatThrownBy(() -> itineraryService.getItineraryDetail(999L, 1L))
                .isInstanceOf(BusinessException.class)
                .extracting("errorCode")
                .isEqualTo(ErrorCode.ITIN_001);
    }

    @Test
    @DisplayName("일정 상세 조회 - 정상 조회")
    void getItineraryDetail_exists_returnsDetail() {
        // given
        Itinerary itinerary = mockCustomItinerary();
        given(itineraryRepository.findById(10L)).willReturn(Optional.of(itinerary));
        given(routeRepository.findByItineraryIdOrderByDayNumberAsc(10L))
                .willReturn(Collections.emptyList());
        given(userItinerarySaveRepository.countByItineraryId(10L)).willReturn(5L);
        given(userItinerarySaveRepository.existsByUserIdAndItineraryId(1L, 10L)).willReturn(true);

        // when
        ItineraryDetailResponse detail = itineraryService.getItineraryDetail(10L, 1L);

        // then
        assertThat(detail).isNotNull();
        assertThat(detail.getId()).isEqualTo(10L);
        assertThat(detail.getSavedCount()).isEqualTo(5L);
        assertThat(detail.isSaved()).isTrue();
    }

    // ── updateItinerary ──────────────────────────────────────────────

    @Test
    @DisplayName("일정 수정 - 타인 일정 수정 시 ITIN_002 예외")
    void updateItinerary_notOwner_throwsItin002() {
        // given
        Itinerary itinerary = mockCustomItinerary();
        given(itineraryRepository.findById(10L)).willReturn(Optional.of(itinerary));
        ItineraryUpdateRequest req = new ItineraryUpdateRequest("수정", 1, Collections.emptyList());

        // when / then
        assertThatThrownBy(() -> itineraryService.updateItinerary(10L, 2L, req))
                .isInstanceOf(BusinessException.class)
                .extracting("errorCode")
                .isEqualTo(ErrorCode.ITIN_002);
    }

    // ── deleteItinerary ──────────────────────────────────────────────

    @Test
    @DisplayName("일정 삭제 - 본인 일정 삭제 성공")
    void deleteItinerary_owner_deletesSuccessfully() {
        // given
        Itinerary itinerary = mockCustomItinerary();
        given(itineraryRepository.findById(10L)).willReturn(Optional.of(itinerary));

        // when
        itineraryService.deleteItinerary(10L, 1L);

        // then
        verify(itineraryRepository).delete(itinerary);
    }

    @Test
    @DisplayName("일정 삭제 - 타인 일정 삭제 시 ITIN_002 예외")
    void deleteItinerary_notOwner_throwsItin002() {
        // given
        Itinerary itinerary = mockCustomItinerary();
        given(itineraryRepository.findById(10L)).willReturn(Optional.of(itinerary));

        // when / then
        assertThatThrownBy(() -> itineraryService.deleteItinerary(10L, 2L))
                .isInstanceOf(BusinessException.class)
                .extracting("errorCode")
                .isEqualTo(ErrorCode.ITIN_002);
    }

    // ── saveItinerary ────────────────────────────────────────────────

    @Test
    @DisplayName("일정 저장 - 중복 저장 시 idempotent (이미 저장 상태 반환)")
    void saveItinerary_alreadySaved_returnsIdempotentResult() {
        // given
        Itinerary itinerary = mockCustomItinerary();
        User user = mockNormalUser();
        given(itineraryRepository.findById(10L)).willReturn(Optional.of(itinerary));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(userItinerarySaveRepository.existsByUserIdAndItineraryId(1L, 10L)).willReturn(true);
        given(userItinerarySaveRepository.countByItineraryId(10L)).willReturn(3L);

        // when
        ItinerarySaveResponse response = itineraryService.saveItinerary(10L, 1L);

        // then
        assertThat(response.saved()).isTrue();
        assertThat(response.savedCount()).isEqualTo(3L);
        verify(userItinerarySaveRepository, never()).save(any());
    }

    @Test
    @DisplayName("일정 저장 - 새로 저장 성공")
    void saveItinerary_notSaved_savesAndReturns() {
        // given
        Itinerary itinerary = mockCustomItinerary();
        User user = mockNormalUser();
        given(itineraryRepository.findById(10L)).willReturn(Optional.of(itinerary));
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(userItinerarySaveRepository.existsByUserIdAndItineraryId(1L, 10L)).willReturn(false);
        given(userItinerarySaveRepository.save(any())).willReturn(mock(UserItinerarySave.class));
        given(userItinerarySaveRepository.countByItineraryId(10L)).willReturn(1L);

        // when
        ItinerarySaveResponse response = itineraryService.saveItinerary(10L, 1L);

        // then
        assertThat(response.saved()).isTrue();
        assertThat(response.savedCount()).isEqualTo(1L);
        verify(userItinerarySaveRepository).save(any(UserItinerarySave.class));
    }

    // ── unsaveItinerary ──────────────────────────────────────────────

    @Test
    @DisplayName("일정 저장 취소 - 정상 취소")
    void unsaveItinerary_success() {
        // given
        Itinerary itinerary = mockCustomItinerary();
        given(itineraryRepository.findById(10L)).willReturn(Optional.of(itinerary));
        given(userItinerarySaveRepository.countByItineraryId(10L)).willReturn(0L);

        // when
        ItinerarySaveResponse response = itineraryService.unsaveItinerary(10L, 1L);

        // then
        assertThat(response.saved()).isFalse();
        assertThat(response.savedCount()).isEqualTo(0L);
        verify(userItinerarySaveRepository).deleteByUserIdAndItineraryId(1L, 10L);
    }

    // ── generateShareLink ────────────────────────────────────────────

    @Test
    @DisplayName("공유 링크 생성 - 정상 생성")
    void generateShareLink_success() {
        // given
        Itinerary itinerary = mockCustomItinerary();
        given(itineraryRepository.findById(10L)).willReturn(Optional.of(itinerary));

        // when
        ShareLinkResponse response = itineraryService.generateShareLink(10L, 1L);

        // then
        assertThat(response.shareUrl()).startsWith("https://jeju.app/share/");
        assertThat(response.expiresAt()).isNotNull();
        verify(itinerary).generateShareToken(any(), any());
    }

    @Test
    @DisplayName("공유 링크 생성 - 존재하지 않는 일정 ITIN_001 예외")
    void generateShareLink_notFound_throwsItin001() {
        // given
        given(itineraryRepository.findById(999L)).willReturn(Optional.empty());

        // when / then
        assertThatThrownBy(() -> itineraryService.generateShareLink(999L, 1L))
                .isInstanceOf(BusinessException.class)
                .extracting("errorCode")
                .isEqualTo(ErrorCode.ITIN_001);
    }

    // ── getAlternativeRoutes ─────────────────────────────────────────

    @Test
    @DisplayName("대체 경로 조회 - 잘못된 reason 파라미터 시 빈 리스트 반환")
    void getAlternativeRoutes_invalidReason_returnsEmpty() {
        // given
        Itinerary itinerary = mockCustomItinerary();
        given(itineraryRepository.findById(10L)).willReturn(Optional.of(itinerary));
        given(routeRepository.findByItineraryIdOrderByDayNumberAsc(10L))
                .willReturn(Collections.emptyList());

        // when
        List<AlternativeItineraryResponse> result =
                itineraryService.getAlternativeRoutes(10L, "INVALID_REASON", 1L);

        // then
        assertThat(result).isEmpty();
    }
}

package com.jeju.jeju.domain.place.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.common.response.PageResponse;
import com.jeju.jeju.domain.place.dto.AutocompleteResponse;
import com.jeju.jeju.domain.place.dto.PlaceDetailResponse;
import com.jeju.jeju.domain.place.dto.PlaceLikeResponse;
import com.jeju.jeju.domain.place.dto.PlaceSummaryResponse;
import com.jeju.jeju.domain.place.entity.TouristSpot;
import com.jeju.jeju.domain.place.entity.UserPlaceLike;
import com.jeju.jeju.domain.place.repository.TouristSpotRepository;
import com.jeju.jeju.domain.place.repository.UserPlaceLikeRepository;
import com.jeju.jeju.domain.review.repository.ReviewRepository;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
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
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyDouble;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class PlaceServiceTest {

    @Mock private TouristSpotRepository touristSpotRepository;
    @Mock private UserPlaceLikeRepository userPlaceLikeRepository;
    @Mock private UserRepository userRepository;
    @Mock private StringRedisTemplate redisTemplate;
    @Mock private ReviewRepository reviewRepository;

    @InjectMocks
    private PlaceService placeService;

    private TouristSpot mockSpot;
    private User mockUser;

    @BeforeEach
    void setUp() {
        mockSpot = mock(TouristSpot.class);
        given(mockSpot.getId()).willReturn(1L);
        given(mockSpot.getName()).willReturn("한라산 국립공원");
        given(mockSpot.getCategory()).willReturn(TouristSpot.Category.NATURE);
        given(mockSpot.getAddress()).willReturn("제주특별자치도 서귀포시");
        given(mockSpot.getThumbnail()).willReturn("https://example.com/thumbnail.jpg");
        given(mockSpot.isHasRamp()).willReturn(true);
        given(mockSpot.isHasElevator()).willReturn(false);
        given(mockSpot.isHasAccessibleToilet()).willReturn(true);
        given(mockSpot.isHasRestZone()).willReturn(false);
        given(mockSpot.isHasAccessibleParking()).willReturn(true);

        mockUser = mock(User.class);
        given(mockUser.getId()).willReturn(1L);
    }

    // ── getPlaces ──────────────────────────────────────────────────

    @Test
    @DisplayName("카테고리 없이 전체 장소 조회 시 findAll 호출")
    void getPlaces_noFilter_callsFindAll() {
        // given
        Pageable pageable = PageRequest.of(0, 20);
        Page<TouristSpot> spotPage = new PageImpl<>(List.of(mockSpot), pageable, 1);
        given(touristSpotRepository.findAll(any(Pageable.class))).willReturn(spotPage);

        // when
        PageResponse<PlaceSummaryResponse> result = placeService.getPlaces(null, null, null, 0, 20, null);

        // then
        assertThat(result).isNotNull();
        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getName()).isEqualTo("한라산 국립공원");
        verify(touristSpotRepository).findAll(any(Pageable.class));
    }

    @Test
    @DisplayName("잘못된 카테고리 값 입력 시 COMMON_001 예외")
    void getPlaces_invalidCategory_throwsCommon001() {
        // given / when / then
        assertThatThrownBy(() -> placeService.getPlaces("INVALID_CAT", null, null, 0, 20, null))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.COMMON_001);
    }

    @Test
    @DisplayName("무장애 필터 ON 시 findByBarrierFree 호출")
    void getPlaces_barrierFreeTrue_callsBarrierFreeQuery() {
        // given
        Pageable pageable = PageRequest.of(0, 20);
        Page<TouristSpot> spotPage = new PageImpl<>(Collections.emptyList(), pageable, 0);
        given(touristSpotRepository.findByBarrierFree(any(Pageable.class))).willReturn(spotPage);

        // when
        PageResponse<PlaceSummaryResponse> result = placeService.getPlaces(null, true, null, 0, 20, null);

        // then
        assertThat(result).isNotNull();
        verify(touristSpotRepository).findByBarrierFree(any(Pageable.class));
    }

    @Test
    @DisplayName("로그인 사용자 조회 시 찜 여부 세팅됨")
    void getPlaces_withUserId_setsLikedFlag() {
        // given
        Pageable pageable = PageRequest.of(0, 20);
        Page<TouristSpot> spotPage = new PageImpl<>(List.of(mockSpot), pageable, 1);
        given(touristSpotRepository.findAll(any(Pageable.class))).willReturn(spotPage);
        given(userPlaceLikeRepository.existsByUserIdAndTouristSpotId(1L, 1L)).willReturn(true);

        // when
        PageResponse<PlaceSummaryResponse> result = placeService.getPlaces(null, null, null, 0, 20, 1L);

        // then
        assertThat(result.getContent().get(0).isLiked()).isTrue();
        verify(userPlaceLikeRepository).existsByUserIdAndTouristSpotId(1L, 1L);
    }

    // ── searchPlaces ───────────────────────────────────────────────

    @Test
    @DisplayName("키워드 검색 시 이름 포함 장소 반환")
    void searchPlaces_validKeyword_returnsMatchingPlaces() {
        // given
        Pageable pageable = PageRequest.of(0, 20);
        Page<TouristSpot> spotPage = new PageImpl<>(List.of(mockSpot), pageable, 1);
        given(touristSpotRepository.findByNameContainingIgnoreCase(anyString(), any(Pageable.class)))
                .willReturn(spotPage);

        // when
        PageResponse<PlaceSummaryResponse> result = placeService.searchPlaces("한라산", 0, 20, null);

        // then
        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getName()).isEqualTo("한라산 국립공원");
        verify(touristSpotRepository).findByNameContainingIgnoreCase("한라산", PageRequest.of(0, 20));
    }

    // ── autocomplete ───────────────────────────────────────────────

    @Test
    @DisplayName("자동완성 키워드 검색 시 최대 limit개 반환")
    void autocomplete_validKeyword_returnsLimitedResults() {
        // given
        given(touristSpotRepository.findTop5ByNameContainingIgnoreCaseOrderByNameAsc("한"))
                .willReturn(List.of(mockSpot));

        // when
        List<AutocompleteResponse> result = placeService.autocomplete("한", 5);

        // then
        assertThat(result).hasSize(1);
        assertThat(result.get(0).name()).isEqualTo("한라산 국립공원");
        assertThat(result.get(0).category()).isEqualTo(TouristSpot.Category.NATURE);
    }

    // ── getPlaceDetail ─────────────────────────────────────────────

    @Test
    @DisplayName("존재하지 않는 장소 조회 시 PLACE_001 예외")
    void getPlaceDetail_notFound_throwsPlace001() {
        // given
        given(touristSpotRepository.findById(999L)).willReturn(Optional.empty());

        // when / then
        assertThatThrownBy(() -> placeService.getPlaceDetail(999L, null))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.PLACE_001);
    }

    @Test
    @DisplayName("로그인 사용자 장소 상세 조회 시 Redis에 최근 본 장소 저장")
    void getPlaceDetail_withUserId_savesRecentToRedis() {
        // given
        given(touristSpotRepository.findById(1L)).willReturn(Optional.of(mockSpot));
        given(mockSpot.getTel()).willReturn(null);
        given(mockSpot.getLat()).willReturn(33.0);
        given(mockSpot.getLng()).willReturn(126.0);
        given(mockSpot.getOpenTime()).willReturn(null);
        given(mockSpot.getCloseTime()).willReturn(null);
        given(mockSpot.getImages()).willReturn(null);
        given(userPlaceLikeRepository.existsByUserIdAndTouristSpotId(1L, 1L)).willReturn(false);

        ZSetOperations<String, String> zSetOps = mock(ZSetOperations.class);
        given(redisTemplate.opsForZSet()).willReturn(zSetOps);

        // when
        PlaceDetailResponse result = placeService.getPlaceDetail(1L, 1L);

        // then
        assertThat(result).isNotNull();
        assertThat(result.getName()).isEqualTo("한라산 국립공원");
        verify(zSetOps).add(anyString(), anyString(), anyDouble());
        verify(zSetOps).removeRange(anyString(), anyLong(), anyLong());
    }

    @Test
    @DisplayName("비로그인 장소 상세 조회 시 Redis 저장 호출 없음")
    void getPlaceDetail_withoutUserId_noRedisOperation() {
        // given
        given(touristSpotRepository.findById(1L)).willReturn(Optional.of(mockSpot));
        given(mockSpot.getTel()).willReturn(null);
        given(mockSpot.getLat()).willReturn(33.0);
        given(mockSpot.getLng()).willReturn(126.0);
        given(mockSpot.getOpenTime()).willReturn(null);
        given(mockSpot.getCloseTime()).willReturn(null);
        given(mockSpot.getImages()).willReturn(null);

        // when
        PlaceDetailResponse result = placeService.getPlaceDetail(1L, null);

        // then
        assertThat(result).isNotNull();
        verify(redisTemplate, never()).opsForZSet();
    }

    // ── likePlace ──────────────────────────────────────────────────

    @Test
    @DisplayName("이미 찜한 장소 재찜 요청 시 liked=true 반환 (idempotent)")
    void likePlace_alreadyLiked_returnsTrue() {
        // given
        given(userPlaceLikeRepository.existsByUserIdAndTouristSpotId(1L, 1L)).willReturn(true);

        // when
        PlaceLikeResponse result = placeService.likePlace(1L, 1L);

        // then
        assertThat(result.liked()).isTrue();
        verify(touristSpotRepository, never()).findById(anyLong());
        verify(userPlaceLikeRepository, never()).save(any(UserPlaceLike.class));
    }

    @Test
    @DisplayName("존재하지 않는 장소 찜 시 PLACE_001 예외")
    void likePlace_spotNotFound_throwsPlace001() {
        // given
        given(userPlaceLikeRepository.existsByUserIdAndTouristSpotId(1L, 999L)).willReturn(false);
        given(touristSpotRepository.findById(999L)).willReturn(Optional.empty());

        // when / then
        assertThatThrownBy(() -> placeService.likePlace(999L, 1L))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.PLACE_001);
    }

    @Test
    @DisplayName("찜하기 성공 시 UserPlaceLike 저장 후 liked=true 반환")
    void likePlace_success_savesLikeAndReturnsTrue() {
        // given
        given(userPlaceLikeRepository.existsByUserIdAndTouristSpotId(1L, 1L)).willReturn(false);
        given(touristSpotRepository.findById(1L)).willReturn(Optional.of(mockSpot));
        given(userRepository.findById(1L)).willReturn(Optional.of(mockUser));

        // when
        PlaceLikeResponse result = placeService.likePlace(1L, 1L);

        // then
        assertThat(result.liked()).isTrue();
        verify(userPlaceLikeRepository).save(any(UserPlaceLike.class));
    }

    // ── unlikePlace ────────────────────────────────────────────────

    @Test
    @DisplayName("찜 취소 시 deleteByUserIdAndTouristSpotId 호출 후 liked=false 반환")
    void unlikePlace_success_deletesLikeAndReturnsFalse() {
        // given (no setup needed — delete is void, no exception thrown)

        // when
        PlaceLikeResponse result = placeService.unlikePlace(1L, 1L);

        // then
        assertThat(result.liked()).isFalse();
        verify(userPlaceLikeRepository).deleteByUserIdAndTouristSpotId(1L, 1L);
    }
}

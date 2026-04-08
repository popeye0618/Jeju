package com.jeju.jeju.domain.review.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.place.entity.TouristSpot;
import com.jeju.jeju.domain.place.repository.TouristSpotRepository;
import com.jeju.jeju.domain.review.dto.ReviewCreateRequest;
import com.jeju.jeju.domain.review.dto.ReviewCreateResponse;
import com.jeju.jeju.domain.review.dto.ReviewListResponse;
import com.jeju.jeju.domain.review.entity.Review;
import com.jeju.jeju.domain.review.repository.ReviewRepository;
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

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.mock;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ReviewServiceTest {

    @InjectMocks
    private ReviewService reviewService;

    @Mock private ReviewRepository reviewRepository;
    @Mock private UserRepository userRepository;
    @Mock private TouristSpotRepository touristSpotRepository;

    private User mockUser() {
        User user = mock(User.class);
        given(user.getId()).willReturn(1L);
        given(user.getNickname()).willReturn("tester");
        return user;
    }

    private TouristSpot mockSpot() {
        TouristSpot spot = mock(TouristSpot.class);
        given(spot.getId()).willReturn(10L);
        return spot;
    }

    private Review mockReview(User user, TouristSpot spot) {
        Review review = mock(Review.class);
        given(review.getId()).willReturn(100L);
        given(review.getUser()).willReturn(user);
        given(review.getRating()).willReturn(4);
        given(review.getContent()).willReturn("좋은 장소입니다.");
        given(review.getImageUrls()).willReturn(List.of());
        given(review.getCreatedAt()).willReturn(LocalDateTime.now());
        given(review.isOwner(1L)).willReturn(true);
        given(review.isOwner(2L)).willReturn(false);
        return review;
    }

    @Test
    @DisplayName("후기 작성 - 정상 (201)")
    void createReview_success() {
        User user = mockUser();
        TouristSpot spot = mockSpot();
        Review review = mockReview(user, spot);

        given(reviewRepository.existsByUserIdAndTouristSpotId(1L, 10L)).willReturn(false);
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(touristSpotRepository.findById(10L)).willReturn(Optional.of(spot));
        given(reviewRepository.save(any())).willReturn(review);

        ReviewCreateRequest req = new ReviewCreateRequest("PLACE", 10L, 4,
                "좋은 장소입니다 정말로", null);
        ReviewCreateResponse response = reviewService.createReview(1L, req);

        assertThat(response).isNotNull();
        assertThat(response.id()).isEqualTo(100L);
        assertThat(response.rating()).isEqualTo(4);
    }

    @Test
    @DisplayName("후기 작성 - 중복 후기 (REVIEW_001)")
    void createReview_duplicate_throwsReview001() {
        given(reviewRepository.existsByUserIdAndTouristSpotId(1L, 10L)).willReturn(true);

        ReviewCreateRequest req = new ReviewCreateRequest("PLACE", 10L, 4,
                "좋은 장소입니다 정말로", null);

        assertThatThrownBy(() -> reviewService.createReview(1L, req))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.REVIEW_001));
    }

    @Test
    @DisplayName("후기 목록 조회 - 정상 (200)")
    void getReviews_success() {
        User user = mockUser();
        TouristSpot spot = mockSpot();
        Review review = mockReview(user, spot);

        Page<Review> page = new PageImpl<>(List.of(review));
        given(reviewRepository.findByTouristSpotIdOrderByCreatedAtDesc(anyLong(), any(Pageable.class)))
                .willReturn(page);
        given(reviewRepository.findAvgRatingByTouristSpotId(10L)).willReturn(Optional.of(4.0));
        given(reviewRepository.countByTouristSpotId(10L)).willReturn(1L);

        ReviewListResponse response = reviewService.getReviews("PLACE", 10L, 0, 10, 1L);

        assertThat(response).isNotNull();
        assertThat(response.getAvgRating()).isEqualTo(4.0);
        assertThat(response.getTotalCount()).isEqualTo(1L);
        assertThat(response.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("후기 삭제 - 본인 후기 삭제 (200)")
    void deleteReview_success() {
        User user = mockUser();
        TouristSpot spot = mockSpot();
        Review review = mockReview(user, spot);

        given(reviewRepository.findByIdAndUserId(100L, 1L)).willReturn(Optional.of(review));

        reviewService.deleteReview(100L, 1L);
    }

    @Test
    @DisplayName("후기 삭제 - 타인 후기 삭제 시도 (ITIN_002)")
    void deleteReview_notOwner_throwsItin002() {
        given(reviewRepository.findByIdAndUserId(100L, 2L)).willReturn(Optional.empty());

        assertThatThrownBy(() -> reviewService.deleteReview(100L, 2L))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.ITIN_002));
    }
}

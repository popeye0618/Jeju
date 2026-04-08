package com.jeju.jeju.domain.review.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.place.entity.TouristSpot;
import com.jeju.jeju.domain.place.repository.TouristSpotRepository;
import com.jeju.jeju.domain.review.dto.ReviewCreateRequest;
import com.jeju.jeju.domain.review.dto.ReviewCreateResponse;
import com.jeju.jeju.domain.review.dto.ReviewListResponse;
import com.jeju.jeju.domain.review.dto.ReviewResponse;
import com.jeju.jeju.domain.review.entity.Review;
import com.jeju.jeju.domain.review.repository.ReviewRepository;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final TouristSpotRepository touristSpotRepository;

    public ReviewService(ReviewRepository reviewRepository,
                         UserRepository userRepository,
                         TouristSpotRepository touristSpotRepository) {
        this.reviewRepository = reviewRepository;
        this.userRepository = userRepository;
        this.touristSpotRepository = touristSpotRepository;
    }

    @Transactional
    public ReviewCreateResponse createReview(Long userId, ReviewCreateRequest req) {
        if ("PLACE".equalsIgnoreCase(req.getTargetType())) {
            if (reviewRepository.existsByUserIdAndTouristSpotId(userId, req.getTargetId())) {
                throw new BusinessException(ErrorCode.REVIEW_001);
            }
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        TouristSpot spot = touristSpotRepository.findById(req.getTargetId())
                .orElseThrow(() -> new BusinessException(ErrorCode.PLACE_001));

        Review review = new Review(user, spot, req.getRating(), req.getContent(), req.getImageUrls());
        Review saved = reviewRepository.save(review);

        return new ReviewCreateResponse(saved.getId(), saved.getRating(), saved.getCreatedAt());
    }

    public ReviewListResponse getReviews(String targetType, Long targetId, int page, int size, Long userId) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Review> reviewPage = reviewRepository.findByTouristSpotIdOrderByCreatedAtDesc(targetId, pageable);

        double avgRating = reviewRepository.findAvgRatingByTouristSpotId(targetId).orElse(0.0);
        long totalCount = reviewRepository.countByTouristSpotId(targetId);

        List<ReviewResponse> responses = reviewPage.getContent().stream()
                .map(r -> ReviewResponse.from(r, userId))
                .collect(Collectors.toList());

        return new ReviewListResponse(
                avgRating,
                totalCount,
                responses,
                reviewPage.getNumber(),
                reviewPage.getSize(),
                reviewPage.getTotalElements(),
                reviewPage.getTotalPages(),
                reviewPage.hasNext()
        );
    }

    @Transactional
    public void deleteReview(Long reviewId, Long userId) {
        Review review = reviewRepository.findByIdAndUserId(reviewId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ITIN_002));
        reviewRepository.delete(review);
    }
}

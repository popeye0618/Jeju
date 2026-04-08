package com.jeju.jeju.domain.review.controller;

import com.jeju.jeju.common.response.ApiResponse;
import com.jeju.jeju.domain.review.dto.ReviewCreateRequest;
import com.jeju.jeju.domain.review.dto.ReviewCreateResponse;
import com.jeju.jeju.domain.review.dto.ReviewListResponse;
import com.jeju.jeju.domain.review.service.ReviewService;
import com.jeju.jeju.security.CustomUserDetails;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/reviews")
public class ReviewController {

    private final ReviewService reviewService;

    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    /**
     * POST /api/v1/reviews
     * 후기 작성. 인증 필요.
     */
    @PostMapping
    public ResponseEntity<ApiResponse<ReviewCreateResponse>> createReview(
            @Valid @RequestBody ReviewCreateRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        ReviewCreateResponse response = reviewService.createReview(userDetails.getUserId(), request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response));
    }

    /**
     * GET /api/v1/reviews
     * 후기 목록 조회. 비로그인 허용.
     */
    @GetMapping
    public ResponseEntity<ApiResponse<ReviewListResponse>> getReviews(
            @RequestParam String targetType,
            @RequestParam Long targetId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Authentication authentication) {
        Long userId = extractUserId(authentication);
        ReviewListResponse response = reviewService.getReviews(targetType, targetId, page, size, userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * DELETE /api/v1/reviews/{id}
     * 후기 삭제. 인증 필요.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteReview(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        reviewService.deleteReview(id, userDetails.getUserId());
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    private Long extractUserId(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) return null;
        Object principal = authentication.getPrincipal();
        if (principal instanceof CustomUserDetails details) {
            return details.getUserId();
        }
        return null;
    }
}

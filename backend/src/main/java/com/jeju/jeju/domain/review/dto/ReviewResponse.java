package com.jeju.jeju.domain.review.dto;

import com.jeju.jeju.domain.review.entity.Review;

import java.time.LocalDateTime;
import java.util.List;

public class ReviewResponse {

    private final Long id;
    private final String nickname;
    private final int rating;
    private final String content;
    private final List<String> imageUrls;
    private final LocalDateTime createdAt;
    private final boolean isOwner;

    private ReviewResponse(Long id, String nickname, int rating, String content,
                           List<String> imageUrls, LocalDateTime createdAt, boolean isOwner) {
        this.id = id;
        this.nickname = nickname;
        this.rating = rating;
        this.content = content;
        this.imageUrls = imageUrls;
        this.createdAt = createdAt;
        this.isOwner = isOwner;
    }

    public static ReviewResponse from(Review review, Long currentUserId) {
        boolean owner = currentUserId != null && review.isOwner(currentUserId);
        return new ReviewResponse(
                review.getId(),
                review.getUser().getNickname(),
                review.getRating(),
                review.getContent(),
                review.getImageUrls(),
                review.getCreatedAt(),
                owner
        );
    }

    public Long getId()                { return id; }
    public String getNickname()        { return nickname; }
    public int getRating()             { return rating; }
    public String getContent()         { return content; }
    public List<String> getImageUrls() { return imageUrls; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public boolean isOwner()           { return isOwner; }
}

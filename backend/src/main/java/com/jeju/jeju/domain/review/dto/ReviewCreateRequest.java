package com.jeju.jeju.domain.review.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;

public class ReviewCreateRequest {

    @NotBlank
    private String targetType;

    @NotNull
    private Long targetId;

    @Min(1)
    @Max(5)
    private int rating;

    @NotBlank
    @Size(min = 10, max = 500)
    private String content;

    @Size(max = 5)
    private List<String> imageUrls;

    public ReviewCreateRequest() {}

    public ReviewCreateRequest(String targetType, Long targetId, int rating, String content, List<String> imageUrls) {
        this.targetType = targetType;
        this.targetId = targetId;
        this.rating = rating;
        this.content = content;
        this.imageUrls = imageUrls;
    }

    public String getTargetType()      { return targetType; }
    public Long getTargetId()          { return targetId; }
    public int getRating()             { return rating; }
    public String getContent()         { return content; }
    public List<String> getImageUrls() { return imageUrls; }
}

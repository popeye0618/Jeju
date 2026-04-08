package com.jeju.jeju.domain.review.dto;

import java.util.List;

public class ReviewListResponse {

    private final double avgRating;
    private final long totalCount;
    private final List<ReviewResponse> content;
    private final int page;
    private final int size;
    private final long totalElements;
    private final int totalPages;
    private final boolean hasNext;

    public ReviewListResponse(double avgRating, long totalCount, List<ReviewResponse> content,
                              int page, int size, long totalElements, int totalPages, boolean hasNext) {
        this.avgRating = avgRating;
        this.totalCount = totalCount;
        this.content = content;
        this.page = page;
        this.size = size;
        this.totalElements = totalElements;
        this.totalPages = totalPages;
        this.hasNext = hasNext;
    }

    public double getAvgRating()           { return avgRating; }
    public long getTotalCount()            { return totalCount; }
    public List<ReviewResponse> getContent() { return content; }
    public int getPage()                   { return page; }
    public int getSize()                   { return size; }
    public long getTotalElements()         { return totalElements; }
    public int getTotalPages()             { return totalPages; }
    public boolean isHasNext()             { return hasNext; }
}

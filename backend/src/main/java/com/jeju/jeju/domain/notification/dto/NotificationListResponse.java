package com.jeju.jeju.domain.notification.dto;

import java.util.List;

public class NotificationListResponse {

    private final long unreadCount;
    private final List<NotificationResponse> content;
    private final int page;
    private final int size;
    private final long totalElements;
    private final int totalPages;
    private final boolean hasNext;

    public NotificationListResponse(long unreadCount, List<NotificationResponse> content,
                                    int page, int size, long totalElements, int totalPages, boolean hasNext) {
        this.unreadCount = unreadCount;
        this.content = content;
        this.page = page;
        this.size = size;
        this.totalElements = totalElements;
        this.totalPages = totalPages;
        this.hasNext = hasNext;
    }

    public long getUnreadCount()                   { return unreadCount; }
    public List<NotificationResponse> getContent() { return content; }
    public int getPage()                           { return page; }
    public int getSize()                           { return size; }
    public long getTotalElements()                 { return totalElements; }
    public int getTotalPages()                     { return totalPages; }
    public boolean isHasNext()                     { return hasNext; }
}

package com.jeju.jeju.domain.notification.dto;

import com.jeju.jeju.domain.notification.entity.Notification;

import java.time.LocalDateTime;

public record NotificationResponse(Long id, String type, String title, String body,
                                   boolean isRead, LocalDateTime createdAt) {

    public static NotificationResponse from(Notification n) {
        return new NotificationResponse(
                n.getId(),
                n.getType().name(),
                n.getTitle(),
                n.getBody(),
                n.isRead(),
                n.getCreatedAt()
        );
    }
}

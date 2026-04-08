package com.jeju.jeju.domain.notification.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.notification.dto.BulkReadResponse;
import com.jeju.jeju.domain.notification.dto.NotificationListResponse;
import com.jeju.jeju.domain.notification.dto.NotificationResponse;
import com.jeju.jeju.domain.notification.dto.ReadNotificationResponse;
import com.jeju.jeju.domain.notification.entity.Notification;
import com.jeju.jeju.domain.notification.repository.NotificationRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class NotificationService {

    private final NotificationRepository notificationRepository;

    public NotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    public NotificationListResponse getNotifications(Long userId, Boolean unreadOnly, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Notification> notifPage;

        if (Boolean.TRUE.equals(unreadOnly)) {
            notifPage = notificationRepository.findByUserIdAndIsReadFalseOrderByCreatedAtDesc(userId, pageable);
        } else {
            notifPage = notificationRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);
        }

        long unreadCount = notificationRepository.countByUserIdAndIsReadFalse(userId);

        List<NotificationResponse> responses = notifPage.getContent().stream()
                .map(NotificationResponse::from)
                .collect(Collectors.toList());

        return new NotificationListResponse(
                unreadCount,
                responses,
                notifPage.getNumber(),
                notifPage.getSize(),
                notifPage.getTotalElements(),
                notifPage.getTotalPages(),
                notifPage.hasNext()
        );
    }

    @Transactional
    public ReadNotificationResponse readNotification(Long notificationId, Long userId) {
        Notification notification = notificationRepository.findByIdAndUserId(notificationId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.COMMON_001));
        notification.markAsRead();
        return new ReadNotificationResponse(notification.getId(), notification.isRead());
    }

    @Transactional
    public BulkReadResponse readAllNotifications(Long userId) {
        List<Notification> unread = notificationRepository.findByUserIdAndIsReadFalse(userId);
        unread.forEach(Notification::markAsRead);
        return new BulkReadResponse(unread.size());
    }

    @Transactional
    public void deleteNotification(Long notificationId, Long userId) {
        Notification notification = notificationRepository.findByIdAndUserId(notificationId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.COMMON_001));
        notificationRepository.delete(notification);
    }
}

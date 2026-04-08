package com.jeju.jeju.domain.notification.controller;

import com.jeju.jeju.common.response.ApiResponse;
import com.jeju.jeju.domain.notification.dto.BulkReadResponse;
import com.jeju.jeju.domain.notification.dto.NotificationListResponse;
import com.jeju.jeju.domain.notification.dto.ReadNotificationResponse;
import com.jeju.jeju.domain.notification.service.NotificationService;
import com.jeju.jeju.security.CustomUserDetails;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    /**
     * GET /api/v1/notifications
     * 알림 목록 조회. 인증 필요.
     */
    @GetMapping
    public ResponseEntity<ApiResponse<NotificationListResponse>> getNotifications(
            @RequestParam(defaultValue = "false") Boolean unreadOnly,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        NotificationListResponse response = notificationService.getNotifications(
                userDetails.getUserId(), unreadOnly, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * PATCH /api/v1/notifications/read-all
     * 알림 전체 읽음 처리. 인증 필요.
     */
    @PatchMapping("/read-all")
    public ResponseEntity<ApiResponse<BulkReadResponse>> readAllNotifications(
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        BulkReadResponse response = notificationService.readAllNotifications(userDetails.getUserId());
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * PATCH /api/v1/notifications/{id}/read
     * 알림 단건 읽음 처리. 인증 필요.
     */
    @PatchMapping("/{id}/read")
    public ResponseEntity<ApiResponse<ReadNotificationResponse>> readNotification(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        ReadNotificationResponse response = notificationService.readNotification(id, userDetails.getUserId());
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    /**
     * DELETE /api/v1/notifications/{id}
     * 알림 삭제. 인증 필요.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteNotification(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        notificationService.deleteNotification(id, userDetails.getUserId());
        return ResponseEntity.ok(ApiResponse.success(null));
    }
}

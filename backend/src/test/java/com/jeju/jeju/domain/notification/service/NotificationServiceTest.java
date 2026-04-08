package com.jeju.jeju.domain.notification.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.notification.dto.BulkReadResponse;
import com.jeju.jeju.domain.notification.dto.NotificationListResponse;
import com.jeju.jeju.domain.notification.dto.ReadNotificationResponse;
import com.jeju.jeju.domain.notification.entity.Notification;
import com.jeju.jeju.domain.notification.repository.NotificationRepository;
import com.jeju.jeju.domain.user.entity.User;
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
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class NotificationServiceTest {

    @InjectMocks
    private NotificationService notificationService;

    @Mock private NotificationRepository notificationRepository;

    private Notification mockNotification(Long id, boolean isRead) {
        Notification n = mock(Notification.class);
        given(n.getId()).willReturn(id);
        given(n.getType()).willReturn(Notification.NotificationType.SYSTEM);
        given(n.getTitle()).willReturn("테스트 알림");
        given(n.getBody()).willReturn("알림 내용입니다.");
        given(n.isRead()).willReturn(isRead);
        given(n.getCreatedAt()).willReturn(LocalDateTime.now());
        return n;
    }

    @Test
    @DisplayName("알림 목록 조회 - 전체 (200)")
    void getNotifications_all_success() {
        Notification n = mockNotification(1L, false);
        Page<Notification> page = new PageImpl<>(List.of(n));

        given(notificationRepository.findByUserIdOrderByCreatedAtDesc(anyLong(), any(Pageable.class)))
                .willReturn(page);
        given(notificationRepository.countByUserIdAndIsReadFalse(1L)).willReturn(1L);

        NotificationListResponse response = notificationService.getNotifications(1L, false, 0, 20);

        assertThat(response).isNotNull();
        assertThat(response.getUnreadCount()).isEqualTo(1L);
        assertThat(response.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("알림 목록 조회 - 미읽음만 (200)")
    void getNotifications_unreadOnly_success() {
        Notification n = mockNotification(1L, false);
        Page<Notification> page = new PageImpl<>(List.of(n));

        given(notificationRepository.findByUserIdAndIsReadFalseOrderByCreatedAtDesc(anyLong(), any(Pageable.class)))
                .willReturn(page);
        given(notificationRepository.countByUserIdAndIsReadFalse(1L)).willReturn(1L);

        NotificationListResponse response = notificationService.getNotifications(1L, true, 0, 20);

        assertThat(response.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("알림 단건 읽음 처리 (200)")
    void readNotification_success() {
        Notification n = mockNotification(1L, false);
        given(notificationRepository.findByIdAndUserId(1L, 1L)).willReturn(Optional.of(n));
        given(n.isRead()).willReturn(true);

        ReadNotificationResponse response = notificationService.readNotification(1L, 1L);

        verify(n).markAsRead();
        assertThat(response.id()).isEqualTo(1L);
    }

    @Test
    @DisplayName("알림 단건 읽음 처리 - 존재하지 않는 알림 (COMMON_001)")
    void readNotification_notFound_throwsCommon001() {
        given(notificationRepository.findByIdAndUserId(99L, 1L)).willReturn(Optional.empty());

        assertThatThrownBy(() -> notificationService.readNotification(99L, 1L))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.COMMON_001));
    }

    @Test
    @DisplayName("알림 전체 읽음 처리 (200)")
    void readAllNotifications_success() {
        Notification n1 = mockNotification(1L, false);
        Notification n2 = mockNotification(2L, false);
        given(notificationRepository.findByUserIdAndIsReadFalse(1L)).willReturn(List.of(n1, n2));

        BulkReadResponse response = notificationService.readAllNotifications(1L);

        verify(n1).markAsRead();
        verify(n2).markAsRead();
        assertThat(response.updatedCount()).isEqualTo(2);
    }

    @Test
    @DisplayName("알림 삭제 - 정상 (200)")
    void deleteNotification_success() {
        Notification n = mockNotification(1L, false);
        given(notificationRepository.findByIdAndUserId(1L, 1L)).willReturn(Optional.of(n));

        notificationService.deleteNotification(1L, 1L);

        verify(notificationRepository).delete(n);
    }

    @Test
    @DisplayName("알림 삭제 - 존재하지 않는 알림 (COMMON_001)")
    void deleteNotification_notFound_throwsCommon001() {
        given(notificationRepository.findByIdAndUserId(99L, 1L)).willReturn(Optional.empty());

        assertThatThrownBy(() -> notificationService.deleteNotification(99L, 1L))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.COMMON_001));
    }
}

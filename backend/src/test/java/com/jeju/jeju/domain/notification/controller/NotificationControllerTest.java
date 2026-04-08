package com.jeju.jeju.domain.notification.controller;

import com.jeju.jeju.domain.notification.dto.BulkReadResponse;
import com.jeju.jeju.domain.notification.dto.NotificationListResponse;
import com.jeju.jeju.domain.notification.dto.ReadNotificationResponse;
import com.jeju.jeju.domain.notification.service.NotificationService;
import com.jeju.jeju.security.CustomUserDetails;
import com.jeju.jeju.security.JwtTokenProvider;
import com.jeju.jeju.security.OAuth2SuccessHandler;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyBoolean;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.doNothing;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(NotificationController.class)
class NotificationControllerTest {

    @Autowired private MockMvc mockMvc;

    @MockitoBean private NotificationService notificationService;
    @MockitoBean private JwtTokenProvider jwtTokenProvider;
    @MockitoBean private OAuth2SuccessHandler oAuth2SuccessHandler;

    private CustomUserDetails mockUserDetails() {
        return new CustomUserDetails(1L, "test@jeju.com", "USER");
    }

    @Test
    @DisplayName("알림 목록 조회 (200)")
    void getNotifications_returns200() throws Exception {
        NotificationListResponse response = new NotificationListResponse(2L, List.of(),
                0, 20, 0L, 0, false);
        given(notificationService.getNotifications(anyLong(), anyBoolean(), anyInt(), anyInt()))
                .willReturn(response);

        mockMvc.perform(get("/api/v1/notifications")
                        .with(user(mockUserDetails())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.unreadCount").value(2));
    }

    @Test
    @DisplayName("알림 전체 읽음 처리 (200)")
    void readAllNotifications_returns200() throws Exception {
        given(notificationService.readAllNotifications(anyLong()))
                .willReturn(new BulkReadResponse(3));

        mockMvc.perform(patch("/api/v1/notifications/read-all")
                        .with(user(mockUserDetails())).with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.updatedCount").value(3));
    }

    @Test
    @DisplayName("알림 단건 읽음 처리 (200)")
    void readNotification_returns200() throws Exception {
        given(notificationService.readNotification(anyLong(), anyLong()))
                .willReturn(new ReadNotificationResponse(1L, true));

        mockMvc.perform(patch("/api/v1/notifications/1/read")
                        .with(user(mockUserDetails())).with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.isRead").value(true));
    }

    @Test
    @DisplayName("알림 삭제 (200)")
    void deleteNotification_returns200() throws Exception {
        doNothing().when(notificationService).deleteNotification(anyLong(), anyLong());

        mockMvc.perform(delete("/api/v1/notifications/1")
                        .with(user(mockUserDetails())).with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }
}

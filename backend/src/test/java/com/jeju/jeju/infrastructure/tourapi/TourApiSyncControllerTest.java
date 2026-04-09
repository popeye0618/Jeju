package com.jeju.jeju.infrastructure.tourapi;

import com.jeju.jeju.security.CustomUserDetails;
import com.jeju.jeju.security.JwtTokenProvider;
import com.jeju.jeju.security.OAuth2SuccessHandler;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(TourApiSyncController.class)
class TourApiSyncControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private TourApiSyncService tourApiSyncService;

    @MockitoBean
    private JwtTokenProvider jwtTokenProvider;

    @MockitoBean
    private OAuth2SuccessHandler oAuth2SuccessHandler;

    private CustomUserDetails adminUserDetails() {
        return new CustomUserDetails(1L, "admin@jeju.com", "ADMIN");
    }

    @Test
    @DisplayName("POST /api/v1/admin/sync/tour — 202 Accepted 즉시 반환")
    void syncTour_returns202Accepted() throws Exception {
        // when / then
        mockMvc.perform(post("/api/v1/admin/sync/tour")
                        .with(user(adminUserDetails()))
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isAccepted())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value("동기화가 시작되었습니다."));
    }
}

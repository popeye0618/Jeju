package com.jeju.jeju.domain.report.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.report.dto.ReportCreateRequest;
import com.jeju.jeju.domain.report.dto.ReportCreateResponse;
import com.jeju.jeju.domain.report.service.ReportService;
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

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.BDDMockito.given;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ReportController.class)
class ReportControllerTest {

    @Autowired private MockMvc mockMvc;

    @MockitoBean private ReportService reportService;
    @MockitoBean private JwtTokenProvider jwtTokenProvider;
    @MockitoBean private OAuth2SuccessHandler oAuth2SuccessHandler;

    private final ObjectMapper objectMapper = new ObjectMapper();

    private CustomUserDetails mockUserDetails() {
        return new CustomUserDetails(1L, "test@jeju.com", "USER");
    }

    @Test
    @DisplayName("신고 접수 - 정상 (201)")
    void createReport_success_returns201() throws Exception {
        given(reportService.createReport(anyLong(), any()))
                .willReturn(new ReportCreateResponse(1L, "PENDING"));

        ReportCreateRequest req = new ReportCreateRequest("PLACE", 10L, "스팸", null, null);

        mockMvc.perform(post("/api/v1/reports")
                        .with(user(mockUserDetails())).with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.status").value("PENDING"));
    }

    @Test
    @DisplayName("신고 접수 - 중복 신고 (409)")
    void createReport_duplicate_returns409() throws Exception {
        given(reportService.createReport(anyLong(), any()))
                .willThrow(new BusinessException(ErrorCode.REPORT_001));

        ReportCreateRequest req = new ReportCreateRequest("PLACE", 10L, "스팸", null, null);

        mockMvc.perform(post("/api/v1/reports")
                        .with(user(mockUserDetails())).with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isConflict());
    }
}

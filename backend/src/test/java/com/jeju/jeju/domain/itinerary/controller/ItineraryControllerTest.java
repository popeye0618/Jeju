package com.jeju.jeju.domain.itinerary.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.common.response.PageResponse;
import com.jeju.jeju.domain.itinerary.dto.*;
import com.jeju.jeju.domain.itinerary.entity.Itinerary.ItineraryType;
import com.jeju.jeju.domain.itinerary.service.ItineraryService;
import com.jeju.jeju.security.CustomUserDetails;
import com.jeju.jeju.security.JwtTokenProvider;
import com.jeju.jeju.security.OAuth2SuccessHandler;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.doNothing;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(ItineraryController.class)
class ItineraryControllerTest {

    @Autowired private MockMvc mockMvc;

    @MockitoBean private ItineraryService itineraryService;
    @MockitoBean private JwtTokenProvider jwtTokenProvider;
    @MockitoBean private OAuth2SuccessHandler oAuth2SuccessHandler;

    private final ObjectMapper objectMapper = new ObjectMapper();

    private CustomUserDetails mockUserDetails() {
        return new CustomUserDetails(1L, "test@jeju.com", "USER");
    }

    private ItinerarySummaryResponse buildSummary() {
        return new ItinerarySummaryResponse(
                1L, "테스트 일정", null, 3, 270, 80, ItineraryType.CUSTOM, null, false);
    }

    private PageResponse<ItinerarySummaryResponse> buildPageResponse() {
        PageImpl<ItinerarySummaryResponse> page = new PageImpl<>(
                List.of(buildSummary()), PageRequest.of(0, 10), 1);
        return PageResponse.of(page);
    }

    // ── GET /api/v1/itineraries/recommend ─────────────────────────────

    @Test
    @DisplayName("추천 일정 조회 - 인증된 사용자 (200)")
    void recommendItineraries_authenticated_withNullDate_returns200() throws Exception {
        given(itineraryService.recommendItineraries(any(), any()))
                .willReturn(buildPageResponse());

        mockMvc.perform(get("/api/v1/itineraries/recommend")
                        .with(user(mockUserDetails())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("추천 일정 조회 - 로그인 사용자 (200)")
    void recommendItineraries_authenticated_returns200() throws Exception {
        given(itineraryService.recommendItineraries(any(), any()))
                .willReturn(buildPageResponse());

        mockMvc.perform(get("/api/v1/itineraries/recommend")
                        .with(user(mockUserDetails())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    // ── GET /api/v1/itineraries/my ────────────────────────────────────

    @Test
    @DisplayName("내 저장 일정 조회 - 인증 필요 (200)")
    void getMyItineraries_authenticated_returns200() throws Exception {
        given(itineraryService.getMyItineraries(any(), anyInt(), anyInt()))
                .willReturn(buildPageResponse());

        mockMvc.perform(get("/api/v1/itineraries/my")
                        .with(user(mockUserDetails())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    // ── POST /api/v1/itineraries ──────────────────────────────────────

    @Test
    @DisplayName("일정 생성 - 정상 요청 시 201 반환")
    void createItinerary_validRequest_returns201() throws Exception {
        given(itineraryService.createItinerary(any(), any(ItineraryCreateRequest.class)))
                .willReturn(buildSummary());

        ItineraryCreateRequest req = new ItineraryCreateRequest(
                "제주 여행", 2,
                List.of(new ItineraryPlaceRequest(1L, 1, 1)));

        mockMvc.perform(post("/api/v1/itineraries")
                        .with(user(mockUserDetails()))
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("일정 생성 - 제목 누락 시 400 반환")
    void createItinerary_missingTitle_returns400() throws Exception {
        ItineraryCreateRequest req = new ItineraryCreateRequest("", 1, Collections.emptyList());

        mockMvc.perform(post("/api/v1/itineraries")
                        .with(user(mockUserDetails()))
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isBadRequest());
    }

    // ── GET /api/v1/itineraries/{id} ──────────────────────────────────

    @Test
    @DisplayName("일정 상세 조회 - 인증된 사용자 정상 조회 (200)")
    void getItineraryDetail_authenticated_returns200() throws Exception {
        ItineraryDetailResponse detail = new ItineraryDetailResponse(
                1L, "테스트 일정", 2, 180, 5L, false, Collections.emptyList());
        given(itineraryService.getItineraryDetail(anyLong(), any()))
                .willReturn(detail);

        mockMvc.perform(get("/api/v1/itineraries/1")
                        .with(user(mockUserDetails())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.title").value("테스트 일정"));
    }

    @Test
    @DisplayName("일정 상세 조회 - 존재하지 않는 일정 404")
    void getItineraryDetail_notFound_returns404() throws Exception {
        given(itineraryService.getItineraryDetail(anyLong(), any()))
                .willThrow(new BusinessException(ErrorCode.ITIN_001));

        mockMvc.perform(get("/api/v1/itineraries/999")
                        .with(user(mockUserDetails())))
                .andExpect(status().isNotFound());
    }

    // ── PUT /api/v1/itineraries/{id} ──────────────────────────────────

    @Test
    @DisplayName("일정 수정 - 인증된 사용자 정상 수정 (200)")
    void updateItinerary_authenticated_returns200() throws Exception {
        given(itineraryService.updateItinerary(anyLong(), any(), any(ItineraryUpdateRequest.class)))
                .willReturn(buildSummary());

        ItineraryUpdateRequest req = new ItineraryUpdateRequest(
                "수정된 제주 여행", 2, Collections.emptyList());

        mockMvc.perform(put("/api/v1/itineraries/1")
                        .with(user(mockUserDetails()))
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("일정 수정 - 타인 일정 수정 시 403 반환")
    void updateItinerary_notOwner_returns403() throws Exception {
        given(itineraryService.updateItinerary(anyLong(), any(), any(ItineraryUpdateRequest.class)))
                .willThrow(new BusinessException(ErrorCode.ITIN_002));

        ItineraryUpdateRequest req = new ItineraryUpdateRequest("수정", 1, Collections.emptyList());

        mockMvc.perform(put("/api/v1/itineraries/1")
                        .with(user(mockUserDetails()))
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isForbidden());
    }

    // ── DELETE /api/v1/itineraries/{id} ───────────────────────────────

    @Test
    @DisplayName("일정 삭제 - 인증된 사용자 성공 (200)")
    void deleteItinerary_authenticated_returns200() throws Exception {
        doNothing().when(itineraryService).deleteItinerary(anyLong(), any());

        mockMvc.perform(delete("/api/v1/itineraries/1")
                        .with(user(mockUserDetails()))
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    // ── POST /api/v1/itineraries/{id}/save ────────────────────────────

    @Test
    @DisplayName("일정 저장 - 성공 (200)")
    void saveItinerary_authenticated_returns200() throws Exception {
        given(itineraryService.saveItinerary(anyLong(), any()))
                .willReturn(new ItinerarySaveResponse(true, 10L));

        mockMvc.perform(post("/api/v1/itineraries/1/save")
                        .with(user(mockUserDetails()))
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.saved").value(true))
                .andExpect(jsonPath("$.data.savedCount").value(10));
    }

    // ── DELETE /api/v1/itineraries/{id}/save ──────────────────────────

    @Test
    @DisplayName("일정 저장 취소 - 성공 (200)")
    void unsaveItinerary_authenticated_returns200() throws Exception {
        given(itineraryService.unsaveItinerary(anyLong(), any()))
                .willReturn(new ItinerarySaveResponse(false, 9L));

        mockMvc.perform(delete("/api/v1/itineraries/1/save")
                        .with(user(mockUserDetails()))
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.saved").value(false));
    }

    // ── GET /api/v1/itineraries/{id}/alternative ──────────────────────

    @Test
    @DisplayName("대체 경로 조회 - 성공 (200)")
    void getAlternativeRoutes_authenticated_returns200() throws Exception {
        given(itineraryService.getAlternativeRoutes(anyLong(), anyString(), any()))
                .willReturn(Collections.emptyList());

        mockMvc.perform(get("/api/v1/itineraries/1/alternative")
                        .with(user(mockUserDetails()))
                        .param("reason", "WEATHER"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    // ── POST /api/v1/itineraries/{id}/share ───────────────────────────

    @Test
    @DisplayName("공유 링크 생성 - 성공 (200)")
    void generateShareLink_authenticated_returns200() throws Exception {
        given(itineraryService.generateShareLink(anyLong(), any()))
                .willReturn(new ShareLinkResponse(
                        "https://jeju.app/share/test-token",
                        LocalDateTime.now().plusDays(7)));

        mockMvc.perform(post("/api/v1/itineraries/1/share")
                        .with(user(mockUserDetails()))
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.shareUrl").value("https://jeju.app/share/test-token"));
    }
}

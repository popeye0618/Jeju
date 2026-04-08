package com.jeju.jeju.domain.place.controller;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.common.response.PageResponse;
import com.jeju.jeju.domain.place.dto.AutocompleteResponse;
import com.jeju.jeju.domain.place.dto.PlaceDetailResponse;
import com.jeju.jeju.domain.place.dto.PlaceLikeResponse;
import com.jeju.jeju.domain.place.dto.PlaceSummaryResponse;
import com.jeju.jeju.domain.place.dto.RecentPlaceResponse;
import com.jeju.jeju.domain.place.entity.TouristSpot;
import com.jeju.jeju.domain.place.service.PlaceService;
import com.jeju.jeju.security.JwtTokenProvider;
import com.jeju.jeju.security.OAuth2SuccessHandler;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Collections;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.BDDMockito.given;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(PlaceController.class)
class PlaceControllerTest {

    @Autowired private MockMvc mockMvc;

    @MockitoBean private PlaceService placeService;
    @MockitoBean private JwtTokenProvider jwtTokenProvider;
    @MockitoBean private OAuth2SuccessHandler oAuth2SuccessHandler;

    // ── GET /api/v1/places ─────────────────────────────────────────

    @Test
    @DisplayName("장소 목록 조회 성공 시 200 반환")
    @WithMockUser
    void getPlaces_success_returns200() throws Exception {
        // given
        PlaceSummaryResponse dto = new PlaceSummaryResponse();
        Page<PlaceSummaryResponse> page = new PageImpl<>(List.of(dto), PageRequest.of(0, 20), 1);
        PageResponse<PlaceSummaryResponse> response = PageResponse.of(page);
        given(placeService.getPlaces(isNull(), isNull(), isNull(), anyInt(), anyInt(), any()))
                .willReturn(response);

        // when / then
        mockMvc.perform(get("/api/v1/places"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    // ── GET /api/v1/places/search ──────────────────────────────────

    @Test
    @DisplayName("키워드 검색 성공 시 200 반환")
    @WithMockUser
    void searchPlaces_validKeyword_returns200() throws Exception {
        // given
        Page<PlaceSummaryResponse> page = new PageImpl<>(Collections.emptyList(), PageRequest.of(0, 20), 0);
        PageResponse<PlaceSummaryResponse> response = PageResponse.of(page);
        given(placeService.searchPlaces(anyString(), anyInt(), anyInt(), any()))
                .willReturn(response);

        // when / then
        mockMvc.perform(get("/api/v1/places/search").param("q", "한라산"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("q 파라미터 없이 검색 시 400 반환")
    @WithMockUser
    void searchPlaces_missingKeyword_returns400() throws Exception {
        // given / when / then
        mockMvc.perform(get("/api/v1/places/search"))
                .andExpect(status().isBadRequest());
    }

    // ── GET /api/v1/places/search/autocomplete ─────────────────────

    @Test
    @DisplayName("자동완성 성공 시 200 반환")
    @WithMockUser
    void autocomplete_validKeyword_returns200() throws Exception {
        // given
        List<AutocompleteResponse> suggestions = List.of(
                new AutocompleteResponse(1L, "한라산 국립공원", TouristSpot.Category.NATURE));
        given(placeService.autocomplete(anyString(), anyInt())).willReturn(suggestions);

        // when / then
        mockMvc.perform(get("/api/v1/places/search/autocomplete").param("q", "한"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data[0].name").value("한라산 국립공원"));
    }

    // ── GET /api/v1/places/{id} ────────────────────────────────────

    @Test
    @DisplayName("장소 상세 조회 성공 시 200 반환")
    @WithMockUser
    void getPlaceDetail_exists_returns200() throws Exception {
        // given
        PlaceDetailResponse detail = new PlaceDetailResponse();
        given(placeService.getPlaceDetail(anyLong(), any())).willReturn(detail);

        // when / then
        mockMvc.perform(get("/api/v1/places/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("존재하지 않는 장소 상세 조회 시 404 반환")
    @WithMockUser
    void getPlaceDetail_notFound_returns404() throws Exception {
        // given
        given(placeService.getPlaceDetail(anyLong(), any()))
                .willThrow(new BusinessException(ErrorCode.PLACE_001));

        // when / then
        mockMvc.perform(get("/api/v1/places/999"))
                .andExpect(status().isNotFound());
    }

    // ── GET /api/v1/places/liked ───────────────────────────────────

    @Test
    @DisplayName("찜 목록 조회 성공 시 200 반환 (인증 필요)")
    @WithMockUser
    void getLikedPlaces_authenticated_returns200() throws Exception {
        // given
        Page<PlaceSummaryResponse> page = new PageImpl<>(Collections.emptyList(), PageRequest.of(0, 20), 0);
        PageResponse<PlaceSummaryResponse> response = PageResponse.of(page);
        given(placeService.getLikedPlaces(any(), anyInt(), anyInt())).willReturn(response);

        // when / then
        mockMvc.perform(get("/api/v1/places/liked"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    // ── GET /api/v1/places/recent ──────────────────────────────────

    @Test
    @DisplayName("최근 본 장소 조회 성공 시 200 반환 (인증 필요)")
    @WithMockUser
    void getRecentPlaces_authenticated_returns200() throws Exception {
        // given
        given(placeService.getRecentPlaces(any(), anyInt())).willReturn(Collections.emptyList());

        // when / then
        mockMvc.perform(get("/api/v1/places/recent"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    // ── POST /api/v1/places/{id}/like ──────────────────────────────

    @Test
    @DisplayName("찜하기 성공 시 200 반환 (인증 필요)")
    @WithMockUser
    void likePlace_authenticated_returns200() throws Exception {
        // given
        given(placeService.likePlace(anyLong(), any())).willReturn(new PlaceLikeResponse(true));

        // when / then
        mockMvc.perform(post("/api/v1/places/1/like").with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.liked").value(true));
    }

    // ── DELETE /api/v1/places/{id}/like ───────────────────────────

    @Test
    @DisplayName("찜 취소 성공 시 200 반환 (인증 필요)")
    @WithMockUser
    void unlikePlace_authenticated_returns200() throws Exception {
        // given
        given(placeService.unlikePlace(anyLong(), any())).willReturn(new PlaceLikeResponse(false));

        // when / then
        mockMvc.perform(delete("/api/v1/places/1/like").with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.liked").value(false));
    }
}

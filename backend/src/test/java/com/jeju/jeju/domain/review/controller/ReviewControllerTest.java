package com.jeju.jeju.domain.review.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.review.dto.ReviewCreateRequest;
import com.jeju.jeju.domain.review.dto.ReviewCreateResponse;
import com.jeju.jeju.domain.review.dto.ReviewListResponse;
import com.jeju.jeju.domain.review.dto.ReviewResponse;
import com.jeju.jeju.domain.review.service.ReviewService;
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

import java.time.LocalDateTime;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.doNothing;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ReviewController.class)
class ReviewControllerTest {

    @Autowired private MockMvc mockMvc;

    @MockitoBean private ReviewService reviewService;
    @MockitoBean private JwtTokenProvider jwtTokenProvider;
    @MockitoBean private OAuth2SuccessHandler oAuth2SuccessHandler;

    private final ObjectMapper objectMapper = new ObjectMapper();

    private CustomUserDetails mockUserDetails() {
        return new CustomUserDetails(1L, "test@jeju.com", "USER");
    }

    @Test
    @DisplayName("후기 작성 - 정상 (201)")
    void createReview_success_returns201() throws Exception {
        ReviewCreateResponse response = new ReviewCreateResponse(1L, 4, LocalDateTime.now());
        given(reviewService.createReview(anyLong(), any())).willReturn(response);

        ReviewCreateRequest req = new ReviewCreateRequest("PLACE", 10L, 4,
                "좋은 장소입니다 정말로요", null);

        mockMvc.perform(post("/api/v1/reviews")
                        .with(user(mockUserDetails())).with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("후기 작성 - 중복 후기 (409)")
    void createReview_duplicate_returns409() throws Exception {
        given(reviewService.createReview(anyLong(), any()))
                .willThrow(new BusinessException(ErrorCode.REVIEW_001));

        ReviewCreateRequest req = new ReviewCreateRequest("PLACE", 10L, 4,
                "좋은 장소입니다 정말로요", null);

        mockMvc.perform(post("/api/v1/reviews")
                        .with(user(mockUserDetails())).with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isConflict());
    }

    @Test
    @DisplayName("후기 목록 조회 - 인증된 사용자 (200)")
    void getReviews_authenticated_returns200() throws Exception {
        ReviewListResponse listResponse = new ReviewListResponse(4.0, 1L,
                List.of(), 0, 10, 1L, 1, false);
        given(reviewService.getReviews(anyString(), anyLong(), anyInt(), anyInt(), any()))
                .willReturn(listResponse);

        mockMvc.perform(get("/api/v1/reviews")
                        .with(user(mockUserDetails()))
                        .param("targetType", "PLACE")
                        .param("targetId", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.avgRating").value(4.0));
    }

    @Test
    @DisplayName("후기 삭제 - 정상 (200)")
    void deleteReview_success_returns200() throws Exception {
        doNothing().when(reviewService).deleteReview(anyLong(), anyLong());

        mockMvc.perform(delete("/api/v1/reviews/1")
                        .with(user(mockUserDetails())).with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }
}

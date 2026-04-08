package com.jeju.jeju.domain.user.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jeju.jeju.domain.user.dto.LoginRequest;
import com.jeju.jeju.domain.user.dto.SignupRequest;
import com.jeju.jeju.domain.user.dto.SignupResponse;
import com.jeju.jeju.domain.user.dto.TokenResponse;
import com.jeju.jeju.domain.user.service.AuthService;
import com.jeju.jeju.security.JwtTokenProvider;
import com.jeju.jeju.security.OAuth2SuccessHandler;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AuthController.class)
class AuthControllerTest {

    @Autowired private MockMvc mockMvc;

    @MockitoBean private AuthService authService;
    @MockitoBean private JwtTokenProvider jwtTokenProvider;
    @MockitoBean private OAuth2SuccessHandler oAuth2SuccessHandler;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Test
    @DisplayName("회원가입 성공 시 201 반환")
    @WithMockUser
    void signup_success_returns201() throws Exception {
        SignupRequest req = new SignupRequest("test@example.com", "password123");
        SignupResponse response = new SignupResponse(1L, "test@example.com", false);
        given(authService.signup(any(SignupRequest.class))).willReturn(response);

        mockMvc.perform(post("/api/v1/auth/signup")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.email").value("test@example.com"));
    }

    @Test
    @DisplayName("유효하지 않은 이메일 형식으로 회원가입 시 400 반환")
    @WithMockUser
    void signup_invalidEmail_returns400() throws Exception {
        SignupRequest req = new SignupRequest("not-an-email", "password123");

        mockMvc.perform(post("/api/v1/auth/signup")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("로그인 성공 시 200 및 토큰 반환")
    @WithMockUser
    void login_success_returns200() throws Exception {
        LoginRequest req = new LoginRequest("test@example.com", "password123");
        TokenResponse tokenResponse = new TokenResponse("access", "refresh", "Bearer", 900L);
        given(authService.login(any(LoginRequest.class))).willReturn(tokenResponse);

        mockMvc.perform(post("/api/v1/auth/login")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.tokenType").value("Bearer"));
    }
}

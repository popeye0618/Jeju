package com.jeju.jeju.security;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class JwtTokenProviderTest {

    private JwtTokenProvider jwtTokenProvider;

    @BeforeEach
    void setUp() {
        jwtTokenProvider = new JwtTokenProvider(
                "test-secret-key-must-be-at-least-32-chars-long",
                900L,
                604800L
        );
    }

    @Test
    @DisplayName("Access Token 생성 및 검증 성공")
    void generateAndValidateAccessToken() {
        String token = jwtTokenProvider.generateAccessToken(1L, "USER");

        assertThat(jwtTokenProvider.validateToken(token)).isTrue();
        assertThat(jwtTokenProvider.getUserIdFromToken(token)).isEqualTo(1L);
        assertThat(jwtTokenProvider.getRoleFromToken(token)).isEqualTo("USER");
    }

    @Test
    @DisplayName("Refresh Token 생성 및 검증 성공")
    void generateAndValidateRefreshToken() {
        String token = jwtTokenProvider.generateRefreshToken(2L);

        assertThat(jwtTokenProvider.validateToken(token)).isTrue();
        assertThat(jwtTokenProvider.getUserIdFromToken(token)).isEqualTo(2L);
    }

    @Test
    @DisplayName("유효하지 않은 토큰 검증 실패")
    void validateInvalidToken() {
        assertThat(jwtTokenProvider.validateToken("invalid.token.here")).isFalse();
    }

    @Test
    @DisplayName("빈 토큰 검증 실패")
    void validateEmptyToken() {
        assertThat(jwtTokenProvider.validateToken("")).isFalse();
        assertThat(jwtTokenProvider.validateToken(null)).isFalse();
    }
}

package com.jeju.jeju.domain.user.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.user.dto.*;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import com.jeju.jeju.security.JwtTokenProvider;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.util.ReflectionTestUtils;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock private UserRepository userRepository;
    @Mock private BCryptPasswordEncoder passwordEncoder;
    @Mock private JwtTokenProvider jwtTokenProvider;
    @Mock private StringRedisTemplate redisTemplate;
    @Mock private ValueOperations<String, String> valueOperations;
    @Mock private EmailService emailService;

    @InjectMocks
    private AuthService authService;

    @Test
    @DisplayName("이미 존재하는 이메일로 회원가입 시 AUTH_001 예외")
    void signup_duplicateEmail_throwsAuth001() {
        given(userRepository.existsByEmail("test@example.com")).willReturn(true);

        assertThatThrownBy(() -> authService.signup(new SignupRequest("test@example.com", "password123")))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.AUTH_001);
    }

    @Test
    @DisplayName("새 이메일로 회원가입 성공")
    void signup_newEmail_success() {
        given(userRepository.existsByEmail("new@example.com")).willReturn(false);
        User user = User.ofEmail("new@example.com", "encoded", "tempNick");
        ReflectionTestUtils.setField(user, "id", 1L);
        given(userRepository.save(any(User.class))).willReturn(user);
        given(passwordEncoder.encode(anyString())).willReturn("encoded");

        SignupResponse response = authService.signup(new SignupRequest("new@example.com", "password123"));

        assertThat(response.email()).isEqualTo("new@example.com");
        assertThat(response.emailVerified()).isFalse();
        then(emailService).should().sendVerificationEmail(eq("new@example.com"), anyString());
    }

    @Test
    @DisplayName("존재하지 않는 이메일로 로그인 시 AUTH_001 예외")
    void login_userNotFound_throwsAuth001() {
        given(userRepository.findByEmail("notfound@example.com")).willReturn(Optional.empty());

        assertThatThrownBy(() -> authService.login(new LoginRequest("notfound@example.com", "password")))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.AUTH_001);
    }

    @Test
    @DisplayName("비밀번호 불일치 시 AUTH_001 예외")
    void login_wrongPassword_throwsAuth001() {
        User user = User.ofEmail("test@example.com", "encoded", "nick");
        given(userRepository.findByEmail("test@example.com")).willReturn(Optional.of(user));
        given(passwordEncoder.matches(anyString(), anyString())).willReturn(false);

        assertThatThrownBy(() -> authService.login(new LoginRequest("test@example.com", "wrongpw")))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.AUTH_001);
    }

    @Test
    @DisplayName("이메일 미인증 시 AUTH_002 예외")
    void login_emailNotVerified_throwsAuth002() {
        User user = User.ofEmail("test@example.com", "encoded", "nick");
        given(userRepository.findByEmail("test@example.com")).willReturn(Optional.of(user));
        given(passwordEncoder.matches(anyString(), anyString())).willReturn(true);

        assertThatThrownBy(() -> authService.login(new LoginRequest("test@example.com", "password123")))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.AUTH_002);
    }

    @Test
    @DisplayName("RefreshToken 없음(Redis) 시 AUTH_004 예외")
    void refreshToken_noStoredToken_throwsAuth004() {
        ReflectionTestUtils.setField(authService, "refreshTokenExpiry", 604800L);
        ReflectionTestUtils.setField(authService, "accessTokenExpiry", 900L);

        given(jwtTokenProvider.validateToken("validRefresh")).willReturn(true);
        given(jwtTokenProvider.getUserIdFromToken("validRefresh")).willReturn(1L);
        given(redisTemplate.opsForValue()).willReturn(valueOperations);
        given(valueOperations.get("RT:1")).willReturn(null);

        assertThatThrownBy(() -> authService.refreshToken(new TokenRefreshRequest("validRefresh")))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.AUTH_004);
    }

    @Test
    @DisplayName("잘못된 RefreshToken 검증 실패 시 AUTH_003 예외")
    void refreshToken_invalidToken_throwsAuth003() {
        ReflectionTestUtils.setField(authService, "refreshTokenExpiry", 604800L);
        ReflectionTestUtils.setField(authService, "accessTokenExpiry", 900L);

        given(jwtTokenProvider.validateToken("invalidToken")).willReturn(false);

        assertThatThrownBy(() -> authService.refreshToken(new TokenRefreshRequest("invalidToken")))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.AUTH_003);
    }

    @Test
    @DisplayName("로그아웃 시 Redis에서 RefreshToken 삭제")
    void logout_deletesRefreshTokenFromRedis() {
        authService.logout(1L);
        verify(redisTemplate).delete("RT:1");
    }

    @Test
    @DisplayName("이메일 인증코드 불일치 시 AUTH_001 예외")
    void verifyEmail_wrongCode_throwsAuth001() {
        User user = User.ofEmail("test@example.com", "encoded", "nick");
        user.setVerificationCode("123456", LocalDateTime.now().plusMinutes(10));
        given(userRepository.findByEmail("test@example.com")).willReturn(Optional.of(user));

        assertThatThrownBy(() -> authService.verifyEmail(new EmailVerifyRequest("test@example.com", "000000")))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.AUTH_001);
    }
}

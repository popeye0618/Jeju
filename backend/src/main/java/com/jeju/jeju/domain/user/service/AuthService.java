package com.jeju.jeju.domain.user.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.user.dto.*;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import com.jeju.jeju.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
@Transactional
public class AuthService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final StringRedisTemplate redisTemplate;

    @Value("${jwt.refresh-token-expiry}")
    private long refreshTokenExpiry;

    @Value("${jwt.access-token-expiry}")
    private long accessTokenExpiry;

    public AuthService(UserRepository userRepository,
                       BCryptPasswordEncoder passwordEncoder,
                       JwtTokenProvider jwtTokenProvider,
                       StringRedisTemplate redisTemplate) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenProvider = jwtTokenProvider;
        this.redisTemplate = redisTemplate;
    }

    public SignupResponse signup(SignupRequest req) {
        if (userRepository.existsByEmail(req.email())) {
            throw new BusinessException(ErrorCode.AUTH_001);
        }

        String nickname = "user_" + UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        String encodedPassword = passwordEncoder.encode(req.password());
        User user = User.ofEmail(req.email(), encodedPassword, nickname);
        userRepository.save(user);

        String code = String.format("%06d", new Random().nextInt(1_000_000));
        user.setVerificationCode(code, LocalDateTime.now().plusMinutes(10));

        // TODO: 이메일 발송 서비스 연동 (인증코드: code)

        return new SignupResponse(user.getId(), user.getEmail(), user.isEmailVerified());
    }

    public void verifyEmail(EmailVerifyRequest req) {
        User user = userRepository.findByEmail(req.email())
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        if (user.getVerificationCode() == null
                || !user.getVerificationCode().equals(req.code())
                || user.getVerificationCodeExpiry() == null
                || user.getVerificationCodeExpiry().isBefore(LocalDateTime.now())) {
            throw new BusinessException(ErrorCode.AUTH_001);
        }

        user.verifyEmail();
        user.setVerificationCode(null, null);
    }

    public void resendVerificationEmail(EmailResendRequest req) {
        User user = userRepository.findByEmail(req.email())
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        String code = String.format("%06d", new Random().nextInt(1_000_000));
        user.setVerificationCode(code, LocalDateTime.now().plusMinutes(10));

        // TODO: 이메일 발송 서비스 연동 (재발송 인증코드: code)
    }

    public TokenResponse login(LoginRequest req) {
        User user = userRepository.findByEmail(req.email())
                .orElseThrow(() -> new BusinessException(ErrorCode.AUTH_001));

        if (!passwordEncoder.matches(req.password(), user.getPassword())) {
            throw new BusinessException(ErrorCode.AUTH_001);
        }

        if (!user.isEmailVerified()) {
            throw new BusinessException(ErrorCode.AUTH_002);
        }

        String accessToken = jwtTokenProvider.generateAccessToken(user.getId(), user.getRole().name());
        String refreshToken = jwtTokenProvider.generateRefreshToken(user.getId());

        redisTemplate.opsForValue().set(
                "RT:" + user.getId(),
                refreshToken,
                refreshTokenExpiry,
                TimeUnit.SECONDS
        );

        return new TokenResponse(accessToken, refreshToken, "Bearer", accessTokenExpiry);
    }

    public void forgotPassword(PasswordForgotRequest req) {
        User user = userRepository.findByEmail(req.email())
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        String code = String.format("%06d", new Random().nextInt(1_000_000));
        user.setVerificationCode(code, LocalDateTime.now().plusMinutes(10));

        // TODO: 이메일 발송 서비스 연동 (비밀번호 재설정 코드: code)
    }

    public void resetPassword(PasswordResetRequest req) {
        User user = userRepository.findByEmail(req.email())
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        if (user.getVerificationCode() == null
                || !user.getVerificationCode().equals(req.code())
                || user.getVerificationCodeExpiry() == null
                || user.getVerificationCodeExpiry().isBefore(LocalDateTime.now())) {
            throw new BusinessException(ErrorCode.AUTH_001);
        }

        user.changePassword(passwordEncoder.encode(req.newPassword()));
        user.setVerificationCode(null, null);
    }

    public TokenResponse refreshToken(TokenRefreshRequest req) {
        if (!jwtTokenProvider.validateToken(req.refreshToken())) {
            throw new BusinessException(ErrorCode.AUTH_003);
        }

        Long userId = jwtTokenProvider.getUserIdFromToken(req.refreshToken());
        String storedToken = redisTemplate.opsForValue().get("RT:" + userId);

        if (storedToken == null || !storedToken.equals(req.refreshToken())) {
            throw new BusinessException(ErrorCode.AUTH_004);
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        String newAccessToken = jwtTokenProvider.generateAccessToken(user.getId(), user.getRole().name());

        return new TokenResponse(newAccessToken, req.refreshToken(), "Bearer", accessTokenExpiry);
    }

    public void logout(Long userId) {
        redisTemplate.delete("RT:" + userId);
    }
}

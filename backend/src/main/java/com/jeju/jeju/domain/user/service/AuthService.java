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

import org.springframework.web.client.RestClient;

import java.time.LocalDateTime;
import java.util.Map;
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
    private final EmailService emailService;

    @Value("${jwt.refresh-token-expiry}")
    private long refreshTokenExpiry;

    @Value("${jwt.access-token-expiry}")
    private long accessTokenExpiry;

    public AuthService(UserRepository userRepository,
                       BCryptPasswordEncoder passwordEncoder,
                       JwtTokenProvider jwtTokenProvider,
                       StringRedisTemplate redisTemplate,
                       EmailService emailService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenProvider = jwtTokenProvider;
        this.redisTemplate = redisTemplate;
        this.emailService = emailService;
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

        emailService.sendVerificationEmail(req.email(), code);

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

        emailService.sendVerificationEmail(req.email(), code);
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

        emailService.sendPasswordResetEmail(req.email(), code);
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

    @SuppressWarnings("unchecked")
    public SocialLoginResponse loginWithKakao(KakaoLoginRequest req) {
        // 1. 카카오 API로 유저 정보 조회
        Map<String, Object> kakaoUser;
        try {
            kakaoUser = RestClient.create()
                    .get()
                    .uri("https://kapi.kakao.com/v2/user/me")
                    .header("Authorization", "Bearer " + req.accessToken())
                    .retrieve()
                    .body(Map.class);
        } catch (Exception e) {
            throw new BusinessException(ErrorCode.AUTH_005);
        }

        if (kakaoUser == null) throw new BusinessException(ErrorCode.AUTH_005);

        String providerId = String.valueOf(kakaoUser.get("id"));
        Map<String, Object> kakaoAccount = (Map<String, Object>) kakaoUser.get("kakao_account");
        String email = kakaoAccount != null ? (String) kakaoAccount.get("email") : null;

        // 2. 기존 유저 조회 or 신규 생성
        boolean isNewUser = false;
        User user = userRepository.findByProviderAndProviderId(User.Provider.KAKAO, providerId)
                .orElse(null);

        if (user == null) {
            if (email != null) {
                user = userRepository.findByEmailAndProvider(email, User.Provider.KAKAO).orElse(null);
            }
            if (user == null) {
                String nickname = "user_" + UUID.randomUUID().toString().replace("-", "").substring(0, 8);
                String resolvedEmail = email != null ? email : providerId + "@kakao.local";
                user = User.ofSocial(resolvedEmail, nickname, User.Provider.KAKAO, providerId);
                userRepository.save(user);
                isNewUser = true;
            }
        }

        // 3. JWT 발급
        String accessToken = jwtTokenProvider.generateAccessToken(user.getId(), user.getRole().name());
        String refreshToken = jwtTokenProvider.generateRefreshToken(user.getId());
        redisTemplate.opsForValue().set("RT:" + user.getId(), refreshToken, refreshTokenExpiry, TimeUnit.SECONDS);

        return new SocialLoginResponse(accessToken, refreshToken, "Bearer", accessTokenExpiry, isNewUser);
    }
}

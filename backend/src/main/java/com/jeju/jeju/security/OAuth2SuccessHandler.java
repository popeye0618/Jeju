package com.jeju.jeju.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jeju.jeju.common.response.ApiResponse;
import com.jeju.jeju.domain.user.dto.SocialLoginResponse;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Component
public class OAuth2SuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final UserRepository userRepository;
    private final JwtTokenProvider jwtTokenProvider;
    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public OAuth2SuccessHandler(UserRepository userRepository,
                                JwtTokenProvider jwtTokenProvider,
                                StringRedisTemplate redisTemplate) {
        this.userRepository = userRepository;
        this.jwtTokenProvider = jwtTokenProvider;
        this.redisTemplate = redisTemplate;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        OAuth2AuthenticationToken oauthToken = (OAuth2AuthenticationToken) authentication;
        String registrationId = oauthToken.getAuthorizedClientRegistrationId();
        OAuth2User oAuth2User = oauthToken.getPrincipal();
        Map<String, Object> attributes = oAuth2User.getAttributes();

        String email;
        String providerId;
        User.Provider provider;

        if ("kakao".equals(registrationId)) {
            @SuppressWarnings("unchecked")
            Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");
            email = kakaoAccount != null ? (String) kakaoAccount.get("email") : null;
            providerId = attributes.get("id") != null ? attributes.get("id").toString() : null;
            provider = User.Provider.KAKAO;
        } else {
            email = (String) attributes.get("email");
            providerId = (String) attributes.get("sub");
            provider = User.Provider.GOOGLE;
        }

        if (email == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "이메일 정보를 가져올 수 없습니다.");
            return;
        }

        final String finalEmail = email;
        final String finalProviderId = providerId;
        final User.Provider finalProvider = provider;

        boolean isNewUser = false;
        User user = userRepository.findByEmail(email).orElse(null);
        if (user == null) {
            String nickname = "user_" + email.split("@")[0].replaceAll("[^a-zA-Z0-9]", "")
                    .substring(0, Math.min(8, email.split("@")[0].replaceAll("[^a-zA-Z0-9]", "").length()));
            if (nickname.length() < 2) nickname = "user_" + System.currentTimeMillis() % 100000;
            user = User.ofSocial(finalEmail, nickname, finalProvider, finalProviderId);
            userRepository.save(user);
            isNewUser = true;
        }

        String accessToken = jwtTokenProvider.generateAccessToken(user.getId(), user.getRole().name());
        String refreshToken = jwtTokenProvider.generateRefreshToken(user.getId());

        redisTemplate.opsForValue().set(
                "RT:" + user.getId(),
                refreshToken,
                jwtTokenProvider.getRefreshTokenExpiry(),
                TimeUnit.SECONDS
        );

        SocialLoginResponse socialLoginResponse = new SocialLoginResponse(
                accessToken, refreshToken, "Bearer", jwtTokenProvider.getAccessTokenExpiry(), isNewUser);

        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(
                objectMapper.writeValueAsString(ApiResponse.success(socialLoginResponse))
        );
    }
}

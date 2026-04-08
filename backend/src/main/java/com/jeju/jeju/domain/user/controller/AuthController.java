package com.jeju.jeju.domain.user.controller;

import com.jeju.jeju.common.response.ApiResponse;
import com.jeju.jeju.domain.user.dto.*;
import com.jeju.jeju.domain.user.service.AuthService;
import com.jeju.jeju.security.CustomUserDetails;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/signup")
    public ResponseEntity<ApiResponse<SignupResponse>> signup(@RequestBody @Valid SignupRequest req) {
        SignupResponse response = authService.signup(req);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response));
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<TokenResponse>> login(@RequestBody @Valid LoginRequest req) {
        return ResponseEntity.ok(ApiResponse.success(authService.login(req)));
    }

    @PostMapping("/email/verify")
    public ResponseEntity<ApiResponse<Void>> verifyEmail(@RequestBody @Valid EmailVerifyRequest req) {
        authService.verifyEmail(req);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PostMapping("/email/resend")
    public ResponseEntity<ApiResponse<Void>> resendVerificationEmail(@RequestBody @Valid EmailResendRequest req) {
        authService.resendVerificationEmail(req);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PostMapping("/password/forgot")
    public ResponseEntity<ApiResponse<Void>> forgotPassword(@RequestBody @Valid PasswordForgotRequest req) {
        authService.forgotPassword(req);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PostMapping("/password/reset")
    public ResponseEntity<ApiResponse<Void>> resetPassword(@RequestBody @Valid PasswordResetRequest req) {
        authService.resetPassword(req);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PostMapping("/token/refresh")
    public ResponseEntity<ApiResponse<TokenResponse>> refreshToken(@RequestBody @Valid TokenRefreshRequest req) {
        return ResponseEntity.ok(ApiResponse.success(authService.refreshToken(req)));
    }

    @DeleteMapping("/logout")
    public ResponseEntity<ApiResponse<Void>> logout(@AuthenticationPrincipal CustomUserDetails userDetails) {
        authService.logout(userDetails.getUserId());
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @GetMapping("/oauth/kakao/callback")
    public ResponseEntity<ApiResponse<String>> kakaoCallback() {
        return ResponseEntity.ok(ApiResponse.success("OAuth2 flow is handled by Spring Security"));
    }

    @GetMapping("/oauth/google/callback")
    public ResponseEntity<ApiResponse<String>> googleCallback() {
        return ResponseEntity.ok(ApiResponse.success("OAuth2 flow is handled by Spring Security"));
    }
}

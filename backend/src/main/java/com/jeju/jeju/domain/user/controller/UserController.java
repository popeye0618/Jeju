package com.jeju.jeju.domain.user.controller;

import com.jeju.jeju.common.response.ApiResponse;
import com.jeju.jeju.domain.user.dto.OnboardingRequest;
import com.jeju.jeju.domain.user.dto.ProfileUpdateRequest;
import com.jeju.jeju.domain.user.dto.UserProfileResponse;
import com.jeju.jeju.domain.user.dto.WithdrawRequest;
import com.jeju.jeju.domain.user.service.UserService;
import com.jeju.jeju.security.CustomUserDetails;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/nickname/check")
    public ResponseEntity<ApiResponse<Void>> checkNickname(@RequestParam String nickname) {
        userService.checkNickname(nickname);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PostMapping("/onboarding")
    public ResponseEntity<ApiResponse<Void>> completeOnboarding(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody @Valid OnboardingRequest req) {
        userService.completeOnboarding(userDetails.getUserId(), req);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<UserProfileResponse>> getMyProfile(
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        return ResponseEntity.ok(ApiResponse.success(userService.getMyProfile(userDetails.getUserId())));
    }

    @PatchMapping("/me")
    public ResponseEntity<ApiResponse<UserProfileResponse>> updateMyProfile(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody ProfileUpdateRequest req) {
        return ResponseEntity.ok(ApiResponse.success(
                userService.updateMyProfile(userDetails.getUserId(), req)));
    }

    @DeleteMapping("/me")
    public ResponseEntity<ApiResponse<Void>> withdraw(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody(required = false) WithdrawRequest req) {
        userService.withdraw(userDetails.getUserId(), req != null ? req : new WithdrawRequest());
        return ResponseEntity.ok(ApiResponse.success(null));
    }
}

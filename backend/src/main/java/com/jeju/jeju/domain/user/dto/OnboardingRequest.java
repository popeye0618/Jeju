package com.jeju.jeju.domain.user.dto;

import com.jeju.jeju.domain.user.entity.User;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record OnboardingRequest(
        @NotNull User.Companion companion,
        @NotNull User.Preference preference,
        @NotNull User.Mobility mobility,
        @NotNull @Min(1) @Max(30) Integer days,
        @NotBlank String nickname,
        boolean termsAgreed,
        boolean privacyAgreed
) {}

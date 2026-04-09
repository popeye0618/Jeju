package com.jeju.jeju.domain.user.dto;

import jakarta.validation.constraints.NotBlank;

public record KakaoLoginRequest(
        @NotBlank String accessToken
) {}

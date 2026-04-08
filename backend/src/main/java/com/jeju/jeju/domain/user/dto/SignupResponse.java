package com.jeju.jeju.domain.user.dto;

public record SignupResponse(
        Long userId,
        String email,
        boolean emailVerified
) {}

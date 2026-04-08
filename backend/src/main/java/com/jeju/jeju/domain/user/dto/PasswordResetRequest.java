package com.jeju.jeju.domain.user.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record PasswordResetRequest(
        @NotBlank @Email String email,
        @NotBlank String code,
        @NotBlank @Size(min = 8, max = 20) String newPassword
) {}

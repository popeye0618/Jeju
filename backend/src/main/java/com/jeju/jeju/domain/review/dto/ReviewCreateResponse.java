package com.jeju.jeju.domain.review.dto;

import java.time.LocalDateTime;

public record ReviewCreateResponse(Long id, int rating, LocalDateTime createdAt) {}

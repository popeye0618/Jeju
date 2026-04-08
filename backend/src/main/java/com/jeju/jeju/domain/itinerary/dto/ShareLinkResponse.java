package com.jeju.jeju.domain.itinerary.dto;

import java.time.LocalDateTime;

public record ShareLinkResponse(String shareUrl, LocalDateTime expiresAt) {
}

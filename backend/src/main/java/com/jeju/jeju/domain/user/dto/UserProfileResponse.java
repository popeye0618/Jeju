package com.jeju.jeju.domain.user.dto;

public record UserProfileResponse(
        Long userId,
        String email,
        String nickname,
        String provider,
        String companion,
        String preference,
        String mobility,
        boolean onboardingComplete,
        long savedItineraryCount,
        long likedPlaceCount
) {}

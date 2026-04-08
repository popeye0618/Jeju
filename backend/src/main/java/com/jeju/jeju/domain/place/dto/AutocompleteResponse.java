package com.jeju.jeju.domain.place.dto;

import com.jeju.jeju.domain.place.entity.TouristSpot;

public record AutocompleteResponse(Long id, String name, TouristSpot.Category category) {}

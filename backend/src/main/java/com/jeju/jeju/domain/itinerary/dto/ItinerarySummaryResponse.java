package com.jeju.jeju.domain.itinerary.dto;

import com.jeju.jeju.domain.itinerary.entity.Itinerary;

import java.time.LocalDateTime;

public class ItinerarySummaryResponse {

    private final Long id;
    private final String title;
    private final String thumbnail;
    private final int places;
    private final int estimatedTime;
    private final Integer accessibilityScore;
    private final Itinerary.ItineraryType type;
    private final LocalDateTime savedAt;
    private final boolean isSaved;

    public ItinerarySummaryResponse(Long id, String title, String thumbnail,
                                     int places, int estimatedTime,
                                     Integer accessibilityScore,
                                     Itinerary.ItineraryType type,
                                     LocalDateTime savedAt, boolean isSaved) {
        this.id = id;
        this.title = title;
        this.thumbnail = thumbnail;
        this.places = places;
        this.estimatedTime = estimatedTime;
        this.accessibilityScore = accessibilityScore;
        this.type = type;
        this.savedAt = savedAt;
        this.isSaved = isSaved;
    }

    public Long getId()                          { return id; }
    public String getTitle()                     { return title; }
    public String getThumbnail()                 { return thumbnail; }
    public int getPlaces()                       { return places; }
    public int getEstimatedTime()                { return estimatedTime; }
    public Integer getAccessibilityScore()       { return accessibilityScore; }
    public Itinerary.ItineraryType getType()     { return type; }
    public LocalDateTime getSavedAt()            { return savedAt; }
    public boolean isSaved()                     { return isSaved; }
}

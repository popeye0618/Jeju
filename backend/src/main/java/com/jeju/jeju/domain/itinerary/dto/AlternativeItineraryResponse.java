package com.jeju.jeju.domain.itinerary.dto;

public class AlternativeItineraryResponse {

    private final Long id;
    private final String title;
    private final String reason;
    private final String thumbnail;
    private final int places;
    private final int estimatedTime;
    private final Integer accessibilityScore;

    public AlternativeItineraryResponse(Long id, String title, String reason,
                                         String thumbnail, int places,
                                         int estimatedTime,
                                         Integer accessibilityScore) {
        this.id = id;
        this.title = title;
        this.reason = reason;
        this.thumbnail = thumbnail;
        this.places = places;
        this.estimatedTime = estimatedTime;
        this.accessibilityScore = accessibilityScore;
    }

    public Long getId()                    { return id; }
    public String getTitle()               { return title; }
    public String getReason()              { return reason; }
    public String getThumbnail()           { return thumbnail; }
    public int getPlaces()                 { return places; }
    public int getEstimatedTime()          { return estimatedTime; }
    public Integer getAccessibilityScore() { return accessibilityScore; }
}

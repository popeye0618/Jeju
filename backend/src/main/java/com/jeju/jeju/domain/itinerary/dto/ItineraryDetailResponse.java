package com.jeju.jeju.domain.itinerary.dto;

import java.util.List;

public class ItineraryDetailResponse {

    private final Long id;
    private final String title;
    private final int days;
    private final int estimatedTime;
    private final long savedCount;
    private final boolean isSaved;
    private final List<PlaceInItineraryResponse> places;

    public ItineraryDetailResponse(Long id, String title, int days,
                                    int estimatedTime, long savedCount,
                                    boolean isSaved,
                                    List<PlaceInItineraryResponse> places) {
        this.id = id;
        this.title = title;
        this.days = days;
        this.estimatedTime = estimatedTime;
        this.savedCount = savedCount;
        this.isSaved = isSaved;
        this.places = places;
    }

    public Long getId()                              { return id; }
    public String getTitle()                         { return title; }
    public int getDays()                             { return days; }
    public int getEstimatedTime()                    { return estimatedTime; }
    public long getSavedCount()                      { return savedCount; }
    public boolean isSaved()                         { return isSaved; }
    public List<PlaceInItineraryResponse> getPlaces(){ return places; }
}

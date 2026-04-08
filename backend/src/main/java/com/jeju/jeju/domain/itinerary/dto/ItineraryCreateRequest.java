package com.jeju.jeju.domain.itinerary.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.util.List;

public class ItineraryCreateRequest {

    @NotBlank
    @Size(max = 30)
    private String title;

    @Min(1)
    @Max(5)
    private int days;

    private List<ItineraryPlaceRequest> places;

    public ItineraryCreateRequest() {}

    public ItineraryCreateRequest(String title, int days, List<ItineraryPlaceRequest> places) {
        this.title = title;
        this.days = days;
        this.places = places;
    }

    public String getTitle()                         { return title; }
    public int getDays()                             { return days; }
    public List<ItineraryPlaceRequest> getPlaces()   { return places; }

    public void setTitle(String title)               { this.title = title; }
    public void setDays(int days)                    { this.days = days; }
    public void setPlaces(List<ItineraryPlaceRequest> places) { this.places = places; }
}

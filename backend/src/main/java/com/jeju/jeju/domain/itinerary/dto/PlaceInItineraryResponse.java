package com.jeju.jeju.domain.itinerary.dto;

public class PlaceInItineraryResponse {

    private final Long id;
    private final String name;
    private final int order;
    private final int day;
    private final Double lat;
    private final Double lng;
    private final Integer estimatedMinutes;
    private final boolean hasRamp;
    private final boolean hasElevator;
    private final boolean hasAccessibleToilet;
    private final boolean hasRestZone;
    private final boolean hasAccessibleParking;

    public PlaceInItineraryResponse(Long id, String name, int order, int day,
                                     Double lat, Double lng,
                                     Integer estimatedMinutes,
                                     boolean hasRamp, boolean hasElevator,
                                     boolean hasAccessibleToilet,
                                     boolean hasRestZone,
                                     boolean hasAccessibleParking) {
        this.id = id;
        this.name = name;
        this.order = order;
        this.day = day;
        this.lat = lat;
        this.lng = lng;
        this.estimatedMinutes = estimatedMinutes;
        this.hasRamp = hasRamp;
        this.hasElevator = hasElevator;
        this.hasAccessibleToilet = hasAccessibleToilet;
        this.hasRestZone = hasRestZone;
        this.hasAccessibleParking = hasAccessibleParking;
    }

    public Long getId()                    { return id; }
    public String getName()                { return name; }
    public int getOrder()                  { return order; }
    public int getDay()                    { return day; }
    public Double getLat()                 { return lat; }
    public Double getLng()                 { return lng; }
    public Integer getEstimatedMinutes()   { return estimatedMinutes; }
    public boolean isHasRamp()             { return hasRamp; }
    public boolean isHasElevator()         { return hasElevator; }
    public boolean isHasAccessibleToilet() { return hasAccessibleToilet; }
    public boolean isHasRestZone()         { return hasRestZone; }
    public boolean isHasAccessibleParking(){ return hasAccessibleParking; }
}

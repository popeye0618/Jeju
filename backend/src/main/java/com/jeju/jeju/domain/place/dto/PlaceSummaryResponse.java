package com.jeju.jeju.domain.place.dto;

import com.jeju.jeju.domain.place.entity.TouristSpot;

public class PlaceSummaryResponse {

    private Long id;
    private String name;
    private TouristSpot.Category category;
    private String address;
    private String thumbnail;
    private boolean hasRamp;
    private boolean hasElevator;
    private boolean hasAccessibleToilet;
    private boolean hasRestZone;
    private boolean hasAccessibleParking;
    private boolean isLiked;

    public PlaceSummaryResponse() {}

    public static PlaceSummaryResponse from(TouristSpot spot) {
        PlaceSummaryResponse dto = new PlaceSummaryResponse();
        dto.id = spot.getId();
        dto.name = spot.getName();
        dto.category = spot.getCategory();
        dto.address = spot.getAddress();
        dto.thumbnail = spot.getThumbnail();
        dto.hasRamp = spot.isHasRamp();
        dto.hasElevator = spot.isHasElevator();
        dto.hasAccessibleToilet = spot.isHasAccessibleToilet();
        dto.hasRestZone = spot.isHasRestZone();
        dto.hasAccessibleParking = spot.isHasAccessibleParking();
        dto.isLiked = false;
        return dto;
    }

    public Long getId()                       { return id; }
    public String getName()                   { return name; }
    public TouristSpot.Category getCategory() { return category; }
    public String getAddress()                { return address; }
    public String getThumbnail()              { return thumbnail; }
    public boolean isHasRamp()                { return hasRamp; }
    public boolean isHasElevator()            { return hasElevator; }
    public boolean isHasAccessibleToilet()    { return hasAccessibleToilet; }
    public boolean isHasRestZone()            { return hasRestZone; }
    public boolean isHasAccessibleParking()   { return hasAccessibleParking; }
    public boolean isLiked()                  { return isLiked; }
    public void setLiked(boolean liked)       { this.isLiked = liked; }
}

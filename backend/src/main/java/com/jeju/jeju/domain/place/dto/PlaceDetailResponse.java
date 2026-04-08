package com.jeju.jeju.domain.place.dto;

import com.jeju.jeju.domain.place.entity.TouristSpot;

import java.util.List;

public class PlaceDetailResponse {

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
    private String tel;
    private Double lat;
    private Double lng;
    private String openTime;
    private String closeTime;
    private List<String> images;
    private int reviewCount;
    private double avgRating;

    public PlaceDetailResponse() {}

    public static PlaceDetailResponse from(TouristSpot spot, boolean liked) {
        PlaceDetailResponse dto = new PlaceDetailResponse();
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
        dto.isLiked = liked;
        dto.tel = spot.getTel();
        dto.lat = spot.getLat();
        dto.lng = spot.getLng();
        dto.openTime = spot.getOpenTime();
        dto.closeTime = spot.getCloseTime();
        dto.images = spot.getImages();
        dto.reviewCount = 0;    // TODO: Review 도메인 연동
        dto.avgRating = 0.0;    // TODO: Review 도메인 연동
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
    public String getTel()                    { return tel; }
    public Double getLat()                    { return lat; }
    public Double getLng()                    { return lng; }
    public String getOpenTime()               { return openTime; }
    public String getCloseTime()              { return closeTime; }
    public List<String> getImages()           { return images; }
    public int getReviewCount()               { return reviewCount; }
    public double getAvgRating()              { return avgRating; }

    public void setReviewCount(int reviewCount)   { this.reviewCount = reviewCount; }
    public void setAvgRating(double avgRating)    { this.avgRating = avgRating; }
}

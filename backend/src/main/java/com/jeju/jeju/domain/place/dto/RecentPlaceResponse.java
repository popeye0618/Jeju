package com.jeju.jeju.domain.place.dto;

import com.jeju.jeju.domain.place.entity.TouristSpot;

import java.time.LocalDateTime;

public class RecentPlaceResponse {

    private Long id;
    private String name;
    private TouristSpot.Category category;
    private String thumbnail;
    private LocalDateTime viewedAt;

    public RecentPlaceResponse() {}

    public RecentPlaceResponse(Long id, String name, TouristSpot.Category category,
                                String thumbnail, LocalDateTime viewedAt) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.thumbnail = thumbnail;
        this.viewedAt = viewedAt;
    }

    public Long getId()                       { return id; }
    public String getName()                   { return name; }
    public TouristSpot.Category getCategory() { return category; }
    public String getThumbnail()              { return thumbnail; }
    public LocalDateTime getViewedAt()        { return viewedAt; }
}

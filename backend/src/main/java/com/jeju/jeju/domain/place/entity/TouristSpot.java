package com.jeju.jeju.domain.place.entity;

import com.jeju.jeju.common.entity.BaseTimeEntity;
import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "tourist_spots")
public class TouristSpot extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String contentId;

    @Column(nullable = false)
    private String name;

    private String address;

    private Double lat;

    private Double lng;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Category category;

    private String tel;

    private String openTime;

    private String closeTime;

    @Column(nullable = false)
    private boolean hasRamp = false;

    @Column(nullable = false)
    private boolean hasElevator = false;

    @Column(nullable = false)
    private boolean hasAccessibleToilet = false;

    @Column(nullable = false)
    private boolean hasRestZone = false;

    @Column(nullable = false)
    private boolean hasAccessibleParking = false;

    @Column(nullable = false)
    private int accessibilityScore = 0;

    @Column(columnDefinition = "TEXT")
    private String thumbnail;

    @Column(columnDefinition = "JSON")
    @Convert(converter = StringListConverter.class)
    private List<String> images;

    // ── 생성자 ─────────────────────────────────────

    protected TouristSpot() {}

    // ── Getter ─────────────────────────────────────

    public Long getId()                     { return id; }
    public String getContentId()            { return contentId; }
    public String getName()                 { return name; }
    public String getAddress()              { return address; }
    public Double getLat()                  { return lat; }
    public Double getLng()                  { return lng; }
    public Category getCategory()           { return category; }
    public String getTel()                  { return tel; }
    public String getOpenTime()             { return openTime; }
    public String getCloseTime()            { return closeTime; }
    public boolean isHasRamp()              { return hasRamp; }
    public boolean isHasElevator()          { return hasElevator; }
    public boolean isHasAccessibleToilet()  { return hasAccessibleToilet; }
    public boolean isHasRestZone()          { return hasRestZone; }
    public boolean isHasAccessibleParking() { return hasAccessibleParking; }
    public int getAccessibilityScore()      { return accessibilityScore; }
    public String getThumbnail()            { return thumbnail; }
    public List<String> getImages()         { return images; }

    // ── Enum ──────────────────────────────────────

    public enum Category { NATURE, FOOD, ACCOMMODATION, CULTURE, SHOPPING }
}

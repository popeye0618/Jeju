package com.jeju.jeju.domain.itinerary.entity;

import com.jeju.jeju.common.entity.BaseTimeEntity;
import com.jeju.jeju.domain.user.entity.User;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "itineraries")
public class Itinerary extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = true)
    private User user;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String thumbnail;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ItineraryType type = ItineraryType.CUSTOM;

    @Column(nullable = false)
    private int tripDays = 1;

    private Integer accessibilityScore;

    private String shareToken;

    private LocalDateTime shareExpiresAt;

    @OneToMany(mappedBy = "itinerary", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Route> routes = new ArrayList<>();

    // ── 생성자 ─────────────────────────────────────

    protected Itinerary() {}

    public static Itinerary ofCustom(User user, String title, int tripDays) {
        Itinerary it = new Itinerary();
        it.user = user;
        it.title = title;
        it.tripDays = tripDays;
        it.type = ItineraryType.CUSTOM;
        return it;
    }

    public static Itinerary ofRecommended(User user, String title, int tripDays, String thumbnail, int accessibilityScore) {
        Itinerary it = new Itinerary();
        it.user = user;
        it.title = title;
        it.tripDays = tripDays;
        it.thumbnail = thumbnail;
        it.accessibilityScore = accessibilityScore;
        it.type = ItineraryType.RECOMMENDED;
        return it;
    }

    /** 시스템 추천 일정 — 특정 유저에 귀속되지 않는 공용 추천 코스 */
    public static Itinerary ofSystemRecommended(String title, int tripDays, String thumbnail, int accessibilityScore) {
        Itinerary it = new Itinerary();
        it.user = null;
        it.title = title;
        it.tripDays = tripDays;
        it.thumbnail = thumbnail;
        it.accessibilityScore = accessibilityScore;
        it.type = ItineraryType.RECOMMENDED;
        return it;
    }

    // ── 도메인 메서드 ────────────────────────────────

    public void update(String title, int tripDays) {
        this.title = title;
        this.tripDays = tripDays;
        this.routes.clear();
    }

    public void updateAccessibilityScore(Integer score) {
        this.accessibilityScore = score;
    }

    public void generateShareToken(String token, LocalDateTime expiresAt) {
        this.shareToken = token;
        this.shareExpiresAt = expiresAt;
    }

    public boolean isOwner(Long userId) {
        return this.user != null && this.user.getId().equals(userId);
    }

    // ── Getter ─────────────────────────────────────

    public Long getId()                     { return id; }
    public User getUser()                   { return user; }
    public String getTitle()                { return title; }
    public String getThumbnail()            { return thumbnail; }
    public ItineraryType getType()          { return type; }
    public int getTripDays()                { return tripDays; }
    public Integer getAccessibilityScore()  { return accessibilityScore; }
    public String getShareToken()           { return shareToken; }
    public LocalDateTime getShareExpiresAt(){ return shareExpiresAt; }
    public List<Route> getRoutes()          { return routes; }

    // ── Enum ──────────────────────────────────────

    public enum ItineraryType { RECOMMENDED, CUSTOM }
}

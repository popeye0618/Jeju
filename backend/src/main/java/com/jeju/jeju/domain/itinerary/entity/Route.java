package com.jeju.jeju.domain.itinerary.entity;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "routes")
public class Route {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "itinerary_id", nullable = false)
    private Itinerary itinerary;

    @Column(nullable = false)
    private int dayNumber;

    private Double totalDistanceKm;

    private Double routeScore;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private RiskLevel riskLevel = RiskLevel.SAFE;

    @OneToMany(mappedBy = "route", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("visitOrder ASC")
    private List<RoutePlace> places = new ArrayList<>();

    // ── 생성자 ─────────────────────────────────────

    protected Route() {}

    public Route(Itinerary itinerary, int dayNumber) {
        this.itinerary = itinerary;
        this.dayNumber = dayNumber;
    }

    // ── Getter ─────────────────────────────────────

    public Long getId()               { return id; }
    public Itinerary getItinerary()   { return itinerary; }
    public int getDayNumber()         { return dayNumber; }
    public Double getTotalDistanceKm(){ return totalDistanceKm; }
    public Double getRouteScore()     { return routeScore; }
    public RiskLevel getRiskLevel()   { return riskLevel; }
    public List<RoutePlace> getPlaces(){ return places; }

    // ── Enum ──────────────────────────────────────

    public enum RiskLevel { SAFE, CAUTION, DANGER }
}

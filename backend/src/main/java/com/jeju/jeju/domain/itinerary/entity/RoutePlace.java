package com.jeju.jeju.domain.itinerary.entity;

import com.jeju.jeju.domain.place.entity.TouristSpot;
import jakarta.persistence.*;

@Entity
@Table(name = "route_places")
public class RoutePlace {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "route_id", nullable = false)
    private Route route;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tourist_spot_id", nullable = false)
    private TouristSpot touristSpot;

    @Column(nullable = false)
    private int visitOrder;

    private Integer stayMinutes;

    private Integer travelToNextMin;

    @Column(columnDefinition = "TEXT")
    private String reason;

    // ── 생성자 ─────────────────────────────────────

    protected RoutePlace() {}

    public RoutePlace(Route route, TouristSpot touristSpot, int visitOrder) {
        this.route = route;
        this.touristSpot = touristSpot;
        this.visitOrder = visitOrder;
    }

    // ── Getter ─────────────────────────────────────

    public Long getId()                 { return id; }
    public Route getRoute()             { return route; }
    public TouristSpot getTouristSpot() { return touristSpot; }
    public int getVisitOrder()          { return visitOrder; }
    public Integer getStayMinutes()     { return stayMinutes; }
    public Integer getTravelToNextMin() { return travelToNextMin; }
    public String getReason()           { return reason; }
}

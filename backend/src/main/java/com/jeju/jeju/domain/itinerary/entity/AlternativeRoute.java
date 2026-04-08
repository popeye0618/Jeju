package com.jeju.jeju.domain.itinerary.entity;

import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(name = "alternative_routes")
@EntityListeners(AuditingEntityListener.class)
public class AlternativeRoute {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "original_route_id", nullable = false)
    private Route originalRoute;

    @Enumerated(EnumType.STRING)
    private TriggerReason triggerReason;

    @Column(columnDefinition = "JSON")
    private String altRouteJson;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    protected AlternativeRoute() {}

    public AlternativeRoute(Route originalRoute, TriggerReason triggerReason, String altRouteJson) {
        this.originalRoute = originalRoute;
        this.triggerReason = triggerReason;
        this.altRouteJson = altRouteJson;
    }

    public Long getId()                 { return id; }
    public Route getOriginalRoute()     { return originalRoute; }
    public TriggerReason getTriggerReason() { return triggerReason; }
    public String getAltRouteJson()     { return altRouteJson; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    public enum TriggerReason { WEATHER, ACCESSIBILITY, PREFERENCE }
}

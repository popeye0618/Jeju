package com.jeju.jeju.domain.itinerary.repository;

import com.jeju.jeju.domain.itinerary.entity.AlternativeRoute;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AlternativeRouteRepository extends JpaRepository<AlternativeRoute, Long> {

    List<AlternativeRoute> findByOriginalRouteIdAndTriggerReason(
            Long routeId, AlternativeRoute.TriggerReason reason);
}

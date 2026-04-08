package com.jeju.jeju.domain.itinerary.repository;

import com.jeju.jeju.domain.itinerary.entity.RoutePlace;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RoutePlaceRepository extends JpaRepository<RoutePlace, Long> {

    List<RoutePlace> findByRouteIdOrderByVisitOrderAsc(Long routeId);
}

package com.jeju.jeju.domain.itinerary.repository;

import com.jeju.jeju.domain.itinerary.entity.Route;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RouteRepository extends JpaRepository<Route, Long> {

    List<Route> findByItineraryIdOrderByDayNumberAsc(Long itineraryId);

    void deleteByItineraryId(Long itineraryId);
}

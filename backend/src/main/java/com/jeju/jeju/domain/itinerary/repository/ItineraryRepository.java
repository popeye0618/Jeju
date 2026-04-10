package com.jeju.jeju.domain.itinerary.repository;

import com.jeju.jeju.domain.itinerary.entity.Itinerary;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ItineraryRepository extends JpaRepository<Itinerary, Long> {

    Page<Itinerary> findByUserIdOrderByCreatedAtDesc(Long userId, Pageable pageable);

    Page<Itinerary> findByTypeOrderByCreatedAtDesc(Itinerary.ItineraryType type, Pageable pageable);

    long countByType(Itinerary.ItineraryType type);
}

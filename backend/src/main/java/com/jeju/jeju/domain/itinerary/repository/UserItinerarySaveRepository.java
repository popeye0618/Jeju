package com.jeju.jeju.domain.itinerary.repository;

import com.jeju.jeju.domain.itinerary.entity.UserItinerarySave;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;

import java.util.Optional;

public interface UserItinerarySaveRepository extends JpaRepository<UserItinerarySave, Long> {

    Optional<UserItinerarySave> findByUserIdAndItineraryId(Long userId, Long itineraryId);

    boolean existsByUserIdAndItineraryId(Long userId, Long itineraryId);

    long countByItineraryId(Long itineraryId);

    @Modifying
    @Transactional
    void deleteByUserIdAndItineraryId(Long userId, Long itineraryId);

    Page<UserItinerarySave> findByUserIdOrderByCreatedAtDesc(Long userId, Pageable pageable);
}

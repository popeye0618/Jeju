package com.jeju.jeju.domain.review.repository;

import com.jeju.jeju.domain.review.entity.Review;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface ReviewRepository extends JpaRepository<Review, Long> {

    Page<Review> findByTouristSpotIdOrderByCreatedAtDesc(Long spotId, Pageable pageable);

    boolean existsByUserIdAndTouristSpotId(Long userId, Long spotId);

    Optional<Review> findByIdAndUserId(Long id, Long userId);

    long countByTouristSpotId(Long spotId);

    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.touristSpot.id = :spotId")
    Optional<Double> findAvgRatingByTouristSpotId(@Param("spotId") Long spotId);
}

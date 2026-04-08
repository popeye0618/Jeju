package com.jeju.jeju.domain.place.repository;

import com.jeju.jeju.domain.place.entity.UserPlaceLike;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserPlaceLikeRepository extends JpaRepository<UserPlaceLike, Long> {

    Optional<UserPlaceLike> findByUserIdAndTouristSpotId(Long userId, Long spotId);

    boolean existsByUserIdAndTouristSpotId(Long userId, Long spotId);

    Page<UserPlaceLike> findByUserId(Long userId, Pageable pageable);

    @Modifying
    @Transactional
    @Query("DELETE FROM UserPlaceLike u WHERE u.user.id = :userId AND u.touristSpot.id = :spotId")
    void deleteByUserIdAndTouristSpotId(@Param("userId") Long userId, @Param("spotId") Long spotId);
}

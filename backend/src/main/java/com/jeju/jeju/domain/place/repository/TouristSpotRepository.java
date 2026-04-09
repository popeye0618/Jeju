package com.jeju.jeju.domain.place.repository;

import com.jeju.jeju.domain.place.entity.TouristSpot;
import com.jeju.jeju.domain.place.entity.TouristSpot.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface TouristSpotRepository extends JpaRepository<TouristSpot, Long> {

    Page<TouristSpot> findByCategory(Category category, Pageable pageable);

    @Query("SELECT t FROM TouristSpot t WHERE t.accessibilityScore >= 80")
    Page<TouristSpot> findByBarrierFree(Pageable pageable);

    @Query("SELECT t FROM TouristSpot t WHERE t.category = :category AND t.accessibilityScore >= 80")
    Page<TouristSpot> findByCategoryAndBarrierFree(@Param("category") Category category, Pageable pageable);

    Page<TouristSpot> findByNameContainingIgnoreCase(String keyword, Pageable pageable);

    List<TouristSpot> findTop5ByNameContainingIgnoreCaseOrderByNameAsc(String keyword);

    Optional<TouristSpot> findByContentId(String contentId);

    @Query("SELECT t FROM TouristSpot t WHERE t.images IS NULL OR t.images = '[]'")
    List<TouristSpot> findByImagesIsNullOrImagesIsEmpty();
}

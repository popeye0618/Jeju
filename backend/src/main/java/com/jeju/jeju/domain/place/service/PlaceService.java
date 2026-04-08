package com.jeju.jeju.domain.place.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.common.response.PageResponse;
import com.jeju.jeju.domain.place.dto.AutocompleteResponse;
import com.jeju.jeju.domain.place.dto.PlaceDetailResponse;
import com.jeju.jeju.domain.place.dto.PlaceLikeResponse;
import com.jeju.jeju.domain.place.dto.PlaceSummaryResponse;
import com.jeju.jeju.domain.place.dto.RecentPlaceResponse;
import com.jeju.jeju.domain.place.entity.TouristSpot;
import com.jeju.jeju.domain.place.entity.UserPlaceLike;
import com.jeju.jeju.domain.place.repository.TouristSpotRepository;
import com.jeju.jeju.domain.place.repository.UserPlaceLikeRepository;
import com.jeju.jeju.domain.review.repository.ReviewRepository;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class PlaceService {

    private static final int MAX_RECENT = 20;
    private static final String RECENT_KEY_PREFIX = "RECENT:";

    private final TouristSpotRepository touristSpotRepository;
    private final UserPlaceLikeRepository userPlaceLikeRepository;
    private final UserRepository userRepository;
    private final StringRedisTemplate redisTemplate;
    private final ReviewRepository reviewRepository;

    public PlaceService(TouristSpotRepository touristSpotRepository,
                        UserPlaceLikeRepository userPlaceLikeRepository,
                        UserRepository userRepository,
                        StringRedisTemplate redisTemplate,
                        ReviewRepository reviewRepository) {
        this.touristSpotRepository = touristSpotRepository;
        this.userPlaceLikeRepository = userPlaceLikeRepository;
        this.userRepository = userRepository;
        this.redisTemplate = redisTemplate;
        this.reviewRepository = reviewRepository;
    }

    public PageResponse<PlaceSummaryResponse> getPlaces(String category, Boolean barrierFree,
                                                         Integer areaCode, int page, int size, Long userId) {
        Pageable pageable = PageRequest.of(page, size);
        Page<TouristSpot> spots;

        TouristSpot.Category categoryEnum = null;
        if (category != null && !category.isBlank()) {
            try {
                categoryEnum = TouristSpot.Category.valueOf(category.toUpperCase());
            } catch (IllegalArgumentException e) {
                throw new BusinessException(ErrorCode.COMMON_001);
            }
        }

        boolean filterBarrierFree = Boolean.TRUE.equals(barrierFree);

        if (categoryEnum != null && filterBarrierFree) {
            spots = touristSpotRepository.findByCategoryAndBarrierFree(categoryEnum, pageable);
        } else if (categoryEnum != null) {
            spots = touristSpotRepository.findByCategory(categoryEnum, pageable);
        } else if (filterBarrierFree) {
            spots = touristSpotRepository.findByBarrierFree(pageable);
        } else {
            spots = touristSpotRepository.findAll(pageable);
        }

        Page<PlaceSummaryResponse> dtoPage = spots.map(PlaceSummaryResponse::from);

        if (userId != null) {
            dtoPage.getContent().forEach(dto -> {
                boolean liked = userPlaceLikeRepository.existsByUserIdAndTouristSpotId(userId, dto.getId());
                dto.setLiked(liked);
            });
        }

        return PageResponse.of(dtoPage);
    }

    public PageResponse<PlaceSummaryResponse> searchPlaces(String keyword, int page, int size, Long userId) {
        Pageable pageable = PageRequest.of(page, size);
        Page<TouristSpot> spots = touristSpotRepository.findByNameContainingIgnoreCase(keyword, pageable);

        Page<PlaceSummaryResponse> dtoPage = spots.map(PlaceSummaryResponse::from);

        if (userId != null) {
            dtoPage.getContent().forEach(dto -> {
                boolean liked = userPlaceLikeRepository.existsByUserIdAndTouristSpotId(userId, dto.getId());
                dto.setLiked(liked);
            });
        }

        return PageResponse.of(dtoPage);
    }

    public List<AutocompleteResponse> autocomplete(String keyword, int limit) {
        List<TouristSpot> spots = touristSpotRepository.findTop5ByNameContainingIgnoreCaseOrderByNameAsc(keyword);
        return spots.stream()
                .limit(limit)
                .map(s -> new AutocompleteResponse(s.getId(), s.getName(), s.getCategory()))
                .collect(Collectors.toList());
    }

    @Transactional
    public PlaceDetailResponse getPlaceDetail(Long placeId, Long userId) {
        TouristSpot spot = touristSpotRepository.findById(placeId)
                .orElseThrow(() -> new BusinessException(ErrorCode.PLACE_001));

        boolean liked = userId != null
                && userPlaceLikeRepository.existsByUserIdAndTouristSpotId(userId, placeId);
        PlaceDetailResponse response = PlaceDetailResponse.from(spot, liked);
        response.setReviewCount((int) reviewRepository.countByTouristSpotId(placeId));
        response.setAvgRating(reviewRepository.findAvgRatingByTouristSpotId(placeId).orElse(0.0));

        if (userId != null) {
            String key = RECENT_KEY_PREFIX + userId;
            double score = (double) System.currentTimeMillis();
            redisTemplate.opsForZSet().add(key, String.valueOf(placeId), score);
            // 최대 20개 초과 시 가장 오래된 항목 제거
            redisTemplate.opsForZSet().removeRange(key, 0, -(MAX_RECENT + 1));
        }

        return response;
    }

    public List<RecentPlaceResponse> getRecentPlaces(Long userId, int limit) {
        String key = RECENT_KEY_PREFIX + userId;
        Set<ZSetOperations.TypedTuple<String>> tuples =
                redisTemplate.opsForZSet().reverseRangeWithScores(key, 0, limit - 1);

        if (tuples == null || tuples.isEmpty()) {
            return Collections.emptyList();
        }

        return tuples.stream()
                .map(tuple -> {
                    Long spotId = Long.parseLong(tuple.getValue());
                    return touristSpotRepository.findById(spotId).map(spot -> {
                        LocalDateTime viewedAt = LocalDateTime.ofInstant(
                                Instant.ofEpochMilli(tuple.getScore().longValue()),
                                ZoneId.systemDefault());
                        return new RecentPlaceResponse(
                                spot.getId(), spot.getName(), spot.getCategory(),
                                spot.getThumbnail(), viewedAt);
                    }).orElse(null);
                })
                .filter(r -> r != null)
                .collect(Collectors.toList());
    }

    public PageResponse<PlaceSummaryResponse> getLikedPlaces(Long userId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<UserPlaceLike> likes = userPlaceLikeRepository.findByUserId(userId, pageable);

        Page<PlaceSummaryResponse> dtoPage = likes.map(like -> {
            PlaceSummaryResponse dto = PlaceSummaryResponse.from(like.getTouristSpot());
            dto.setLiked(true);
            return dto;
        });

        return PageResponse.of(dtoPage);
    }

    @Transactional
    public PlaceLikeResponse likePlace(Long placeId, Long userId) {
        if (userPlaceLikeRepository.existsByUserIdAndTouristSpotId(userId, placeId)) {
            return new PlaceLikeResponse(true);
        }

        TouristSpot spot = touristSpotRepository.findById(placeId)
                .orElseThrow(() -> new BusinessException(ErrorCode.PLACE_001));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        userPlaceLikeRepository.save(new UserPlaceLike(user, spot));
        return new PlaceLikeResponse(true);
    }

    @Transactional
    public PlaceLikeResponse unlikePlace(Long placeId, Long userId) {
        userPlaceLikeRepository.deleteByUserIdAndTouristSpotId(userId, placeId);
        return new PlaceLikeResponse(false);
    }
}

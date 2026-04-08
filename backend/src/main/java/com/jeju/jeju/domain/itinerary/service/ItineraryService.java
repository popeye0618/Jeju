package com.jeju.jeju.domain.itinerary.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.common.response.PageResponse;
import com.jeju.jeju.domain.itinerary.dto.*;
import com.jeju.jeju.domain.itinerary.entity.*;
import com.jeju.jeju.domain.itinerary.entity.AlternativeRoute.TriggerReason;
import com.jeju.jeju.domain.itinerary.entity.Itinerary.ItineraryType;
import com.jeju.jeju.domain.itinerary.repository.*;
import com.jeju.jeju.domain.place.entity.TouristSpot;
import com.jeju.jeju.domain.place.repository.TouristSpotRepository;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class ItineraryService {

    private final ItineraryRepository itineraryRepository;
    private final RouteRepository routeRepository;
    private final RoutePlaceRepository routePlaceRepository;
    private final AlternativeRouteRepository alternativeRouteRepository;
    private final UserItinerarySaveRepository userItinerarySaveRepository;
    private final UserRepository userRepository;
    private final TouristSpotRepository touristSpotRepository;

    public ItineraryService(ItineraryRepository itineraryRepository,
                             RouteRepository routeRepository,
                             RoutePlaceRepository routePlaceRepository,
                             AlternativeRouteRepository alternativeRouteRepository,
                             UserItinerarySaveRepository userItinerarySaveRepository,
                             UserRepository userRepository,
                             TouristSpotRepository touristSpotRepository) {
        this.itineraryRepository = itineraryRepository;
        this.routeRepository = routeRepository;
        this.routePlaceRepository = routePlaceRepository;
        this.alternativeRouteRepository = alternativeRouteRepository;
        this.userItinerarySaveRepository = userItinerarySaveRepository;
        this.userRepository = userRepository;
        this.touristSpotRepository = touristSpotRepository;
    }

    // ── 추천 일정 조회 ──────────────────────────────────────────────

    public PageResponse<ItinerarySummaryResponse> recommendItineraries(Long userId, LocalDate date) {
        Page<Itinerary> all = itineraryRepository.findByTypeOrderByCreatedAtDesc(
                ItineraryType.RECOMMENDED, PageRequest.of(0, 50));

        final boolean requireAccessibility;
        if (userId != null) {
            User user = userRepository.findById(userId).orElse(null);
            if (user != null && user.getMobility() != null) {
                User.Mobility mobility = user.getMobility();
                requireAccessibility = mobility == User.Mobility.WHEELCHAIR
                        || mobility == User.Mobility.STROLLER
                        || mobility == User.Mobility.ELDERLY;
            } else {
                requireAccessibility = false;
            }
        } else {
            requireAccessibility = false;
        }

        List<Itinerary> filtered = all.getContent().stream()
                .filter(it -> !requireAccessibility
                        || (it.getAccessibilityScore() != null && it.getAccessibilityScore() >= 80))
                .limit(3)
                .collect(Collectors.toList());

        List<ItinerarySummaryResponse> responses = filtered.stream()
                .map(it -> toSummary(it, null, isUserSaved(userId, it.getId())))
                .collect(Collectors.toList());

        Page<ItinerarySummaryResponse> page = new PageImpl<>(responses,
                PageRequest.of(0, 3), responses.size());
        return PageResponse.of(page);
    }

    // ── 내 저장 일정 조회 ──────────────────────────────────────────

    public PageResponse<ItinerarySummaryResponse> getMyItineraries(Long userId, int page, int size) {
        Page<UserItinerarySave> saves = userItinerarySaveRepository
                .findByUserIdOrderByCreatedAtDesc(userId, PageRequest.of(page, size));

        Page<ItinerarySummaryResponse> result = saves.map(save -> {
            Itinerary it = save.getItinerary();
            return toSummary(it, save.getCreatedAt(), true);
        });

        return PageResponse.of(result);
    }

    // ── 일정 생성 ──────────────────────────────────────────────────

    @Transactional
    public ItinerarySummaryResponse createItinerary(Long userId, ItineraryCreateRequest req) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        List<ItineraryPlaceRequest> placeReqs = req.getPlaces() != null
                ? req.getPlaces() : Collections.emptyList();

        Map<Long, TouristSpot> spotMap = new LinkedHashMap<>();
        for (ItineraryPlaceRequest pr : placeReqs) {
            if (!spotMap.containsKey(pr.placeId())) {
                TouristSpot spot = touristSpotRepository.findById(pr.placeId())
                        .orElseThrow(() -> new BusinessException(ErrorCode.PLACE_001));
                spotMap.put(pr.placeId(), spot);
            }
        }

        Itinerary itinerary = Itinerary.ofCustom(user, req.getTitle(), req.getDays());

        int avgScore = calcAvgAccessibilityScore(placeReqs, spotMap);
        itinerary.updateAccessibilityScore(avgScore);

        buildRoutes(itinerary, placeReqs, spotMap);

        Itinerary saved = itineraryRepository.save(itinerary);

        UserItinerarySave userSave = new UserItinerarySave(user, saved);
        userItinerarySaveRepository.save(userSave);

        int totalPlaces = countTotalPlaces(saved);
        int estimatedTime = calcEstimatedTimeFromRoutes(saved.getRoutes());
        return new ItinerarySummaryResponse(
                saved.getId(), saved.getTitle(), saved.getThumbnail(),
                totalPlaces, estimatedTime, saved.getAccessibilityScore(),
                saved.getType(), null, true);
    }

    // ── 일정 상세 조회 ─────────────────────────────────────────────

    public ItineraryDetailResponse getItineraryDetail(Long itineraryId, Long userId) {
        Itinerary itinerary = itineraryRepository.findById(itineraryId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ITIN_001));

        List<Route> routes = routeRepository.findByItineraryIdOrderByDayNumberAsc(itineraryId);

        List<PlaceInItineraryResponse> places = new ArrayList<>();
        for (Route route : routes) {
            List<RoutePlace> routePlaces = routePlaceRepository
                    .findByRouteIdOrderByVisitOrderAsc(route.getId());
            for (RoutePlace rp : routePlaces) {
                TouristSpot spot = rp.getTouristSpot();
                places.add(new PlaceInItineraryResponse(
                        spot.getId(),
                        spot.getName(),
                        rp.getVisitOrder(),
                        route.getDayNumber(),
                        spot.getLat(),
                        spot.getLng(),
                        rp.getStayMinutes(),
                        spot.isHasRamp(),
                        spot.isHasElevator(),
                        spot.isHasAccessibleToilet(),
                        spot.isHasRestZone(),
                        spot.isHasAccessibleParking()
                ));
            }
        }

        long savedCount = userItinerarySaveRepository.countByItineraryId(itineraryId);
        boolean isSaved = isUserSaved(userId, itineraryId);
        int estimatedTime = calcEstimatedTimeFromRoutePlaces(
                routes.stream()
                        .flatMap(r -> routePlaceRepository
                                .findByRouteIdOrderByVisitOrderAsc(r.getId()).stream())
                        .collect(Collectors.toList())
        );

        return new ItineraryDetailResponse(
                itinerary.getId(),
                itinerary.getTitle(),
                itinerary.getTripDays(),
                estimatedTime,
                savedCount,
                isSaved,
                places
        );
    }

    // ── 일정 수정 ──────────────────────────────────────────────────

    @Transactional
    public ItinerarySummaryResponse updateItinerary(Long itineraryId, Long userId,
                                                     ItineraryUpdateRequest req) {
        Itinerary itinerary = itineraryRepository.findById(itineraryId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ITIN_001));
        if (!itinerary.isOwner(userId)) {
            throw new BusinessException(ErrorCode.ITIN_002);
        }

        List<ItineraryPlaceRequest> placeReqs = req.getPlaces() != null
                ? req.getPlaces() : Collections.emptyList();

        Map<Long, TouristSpot> spotMap = new LinkedHashMap<>();
        for (ItineraryPlaceRequest pr : placeReqs) {
            if (!spotMap.containsKey(pr.placeId())) {
                TouristSpot spot = touristSpotRepository.findById(pr.placeId())
                        .orElseThrow(() -> new BusinessException(ErrorCode.PLACE_001));
                spotMap.put(pr.placeId(), spot);
            }
        }

        // update() calls routes.clear() — orphanRemoval handles cascade delete
        itinerary.update(req.getTitle(), req.getDays());

        int avgScore = calcAvgAccessibilityScore(placeReqs, spotMap);
        itinerary.updateAccessibilityScore(avgScore);

        buildRoutes(itinerary, placeReqs, spotMap);

        int totalPlaces = countTotalPlaces(itinerary);
        int estimatedTime = calcEstimatedTimeFromRoutes(itinerary.getRoutes());
        return new ItinerarySummaryResponse(
                itinerary.getId(), itinerary.getTitle(), itinerary.getThumbnail(),
                totalPlaces, estimatedTime, itinerary.getAccessibilityScore(),
                itinerary.getType(), null, isUserSaved(userId, itinerary.getId()));
    }

    // ── 일정 삭제 ──────────────────────────────────────────────────

    @Transactional
    public void deleteItinerary(Long itineraryId, Long userId) {
        Itinerary itinerary = itineraryRepository.findById(itineraryId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ITIN_001));
        if (!itinerary.isOwner(userId)) {
            throw new BusinessException(ErrorCode.ITIN_002);
        }
        itineraryRepository.delete(itinerary);
    }

    // ── 일정 저장 ──────────────────────────────────────────────────

    @Transactional
    public ItinerarySaveResponse saveItinerary(Long itineraryId, Long userId) {
        Itinerary itinerary = itineraryRepository.findById(itineraryId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ITIN_001));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        if (!userItinerarySaveRepository.existsByUserIdAndItineraryId(userId, itineraryId)) {
            userItinerarySaveRepository.save(new UserItinerarySave(user, itinerary));
        }

        long count = userItinerarySaveRepository.countByItineraryId(itineraryId);
        return new ItinerarySaveResponse(true, count);
    }

    // ── 일정 저장 취소 ─────────────────────────────────────────────

    @Transactional
    public ItinerarySaveResponse unsaveItinerary(Long itineraryId, Long userId) {
        itineraryRepository.findById(itineraryId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ITIN_001));

        userItinerarySaveRepository.deleteByUserIdAndItineraryId(userId, itineraryId);

        long count = userItinerarySaveRepository.countByItineraryId(itineraryId);
        return new ItinerarySaveResponse(false, count);
    }

    // ── 대체 경로 조회 ─────────────────────────────────────────────

    public List<AlternativeItineraryResponse> getAlternativeRoutes(Long itineraryId,
                                                                     String reason,
                                                                     Long userId) {
        Itinerary itinerary = itineraryRepository.findById(itineraryId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ITIN_001));

        List<Route> routes = routeRepository.findByItineraryIdOrderByDayNumberAsc(itineraryId);
        if (routes.isEmpty()) {
            return Collections.emptyList();
        }

        TriggerReason triggerReason = null;
        if (reason != null && !reason.isBlank()) {
            try {
                triggerReason = TriggerReason.valueOf(reason.toUpperCase());
            } catch (IllegalArgumentException e) {
                return Collections.emptyList();
            }
        }

        List<AlternativeItineraryResponse> result = new ArrayList<>();
        for (Route route : routes) {
            List<AlternativeRoute> alternatives = (triggerReason != null)
                    ? alternativeRouteRepository
                            .findByOriginalRouteIdAndTriggerReason(route.getId(), triggerReason)
                    : Collections.emptyList();

            for (AlternativeRoute alt : alternatives) {
                result.add(new AlternativeItineraryResponse(
                        alt.getId(),
                        itinerary.getTitle() + " (대체 경로)",
                        alt.getTriggerReason() != null ? alt.getTriggerReason().name() : null,
                        itinerary.getThumbnail(),
                        countTotalPlaces(itinerary),
                        0,
                        itinerary.getAccessibilityScore()
                ));
            }
        }
        return result;
    }

    // ── 공유 링크 생성 ─────────────────────────────────────────────

    @Transactional
    public ShareLinkResponse generateShareLink(Long itineraryId, Long userId) {
        Itinerary itinerary = itineraryRepository.findById(itineraryId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ITIN_001));

        String token = UUID.randomUUID().toString();
        LocalDateTime expiresAt = LocalDateTime.now().plusDays(7);
        itinerary.generateShareToken(token, expiresAt);

        return new ShareLinkResponse("https://jeju.app/share/" + token, expiresAt);
    }

    // ── Private helpers ────────────────────────────────────────────

    private boolean isUserSaved(Long userId, Long itineraryId) {
        if (userId == null) return false;
        return userItinerarySaveRepository.existsByUserIdAndItineraryId(userId, itineraryId);
    }

    private ItinerarySummaryResponse toSummary(Itinerary itinerary,
                                                LocalDateTime savedAt,
                                                boolean isSaved) {
        int totalPlaces = countTotalPlaces(itinerary);
        int estimatedTime = calcEstimatedTimeFromRoutes(itinerary.getRoutes());
        return new ItinerarySummaryResponse(
                itinerary.getId(),
                itinerary.getTitle(),
                itinerary.getThumbnail(),
                totalPlaces,
                estimatedTime,
                itinerary.getAccessibilityScore(),
                itinerary.getType(),
                savedAt,
                isSaved
        );
    }

    private int countTotalPlaces(Itinerary itinerary) {
        return itinerary.getRoutes().stream()
                .mapToInt(r -> r.getPlaces().size())
                .sum();
    }

    private int calcEstimatedTimeFromRoutes(List<Route> routes) {
        List<RoutePlace> allPlaces = routes.stream()
                .flatMap(r -> r.getPlaces().stream())
                .collect(Collectors.toList());
        return calcEstimatedTimeFromRoutePlaces(allPlaces);
    }

    private int calcEstimatedTimeFromRoutePlaces(List<RoutePlace> routePlaces) {
        if (routePlaces.isEmpty()) return 0;
        boolean hasStayMinutes = routePlaces.stream()
                .anyMatch(rp -> rp.getStayMinutes() != null);
        if (hasStayMinutes) {
            return routePlaces.stream()
                    .mapToInt(rp -> rp.getStayMinutes() != null ? rp.getStayMinutes() : 0)
                    .sum();
        }
        return routePlaces.size() * 90;
    }

    private int calcAvgAccessibilityScore(List<ItineraryPlaceRequest> placeReqs,
                                           Map<Long, TouristSpot> spotMap) {
        if (placeReqs.isEmpty()) return 0;
        double avg = placeReqs.stream()
                .mapToInt(pr -> spotMap.get(pr.placeId()).getAccessibilityScore())
                .average()
                .orElse(0.0);
        return (int) Math.round(avg);
    }

    private void buildRoutes(Itinerary itinerary,
                              List<ItineraryPlaceRequest> placeReqs,
                              Map<Long, TouristSpot> spotMap) {
        Map<Integer, List<ItineraryPlaceRequest>> byDay = placeReqs.stream()
                .collect(Collectors.groupingBy(ItineraryPlaceRequest::day,
                        TreeMap::new, Collectors.toList()));

        for (Map.Entry<Integer, List<ItineraryPlaceRequest>> entry : byDay.entrySet()) {
            Route route = new Route(itinerary, entry.getKey());
            for (ItineraryPlaceRequest pr : entry.getValue()) {
                TouristSpot spot = spotMap.get(pr.placeId());
                RoutePlace rp = new RoutePlace(route, spot, pr.order());
                route.getPlaces().add(rp);
            }
            itinerary.getRoutes().add(route);
        }
    }
}

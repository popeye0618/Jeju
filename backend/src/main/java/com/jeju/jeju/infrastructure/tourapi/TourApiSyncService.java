package com.jeju.jeju.infrastructure.tourapi;

import com.jeju.jeju.domain.place.entity.TouristSpot;
import com.jeju.jeju.domain.place.entity.TouristSpot.Category;
import com.jeju.jeju.domain.place.repository.TouristSpotRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class TourApiSyncService {

    private static final Logger log = LoggerFactory.getLogger(TourApiSyncService.class);
    private static final int PAGE_SIZE = 100;

    private final TourApiClient tourApiClient;
    private final TouristSpotRepository touristSpotRepository;

    public TourApiSyncService(TourApiClient tourApiClient,
                               TouristSpotRepository touristSpotRepository) {
        this.tourApiClient = tourApiClient;
        this.touristSpotRepository = touristSpotRepository;
    }

    /**
     * 주 1회 새벽 3시 자동 동기화 (매주 일요일)
     */
    @Scheduled(cron = "0 0 3 * * SUN")
    public void syncAll() {
        log.info("관광정보 동기화 시작");

        int totalCount = tourApiClient.fetchTotalCount();
        if (totalCount == 0) {
            log.warn("totalCount=0, 동기화 중단");
            return;
        }

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        log.info("총 {}건, {}페이지 동기화 예정", totalCount, totalPages);

        for (int pageNo = 1; pageNo <= totalPages; pageNo++) {
            try {
                List<TourApiPlaceDto> places = tourApiClient.fetchTourPlaces(pageNo, PAGE_SIZE);
                saveTourSpots(places);
                log.info("관광정보 페이지 {}/{} 저장 완료 ({}건)", pageNo, totalPages, places.size());
            } catch (Exception e) {
                log.error("관광정보 페이지 {} 처리 실패: {}", pageNo, e.getMessage());
            }
        }

        syncBarrierFreeInfo();
        syncImages();

        log.info("관광정보 동기화 완료");
    }

    /**
     * 수동 동기화 트리거 (관리자 API용)
     */
    public void syncNow() {
        syncAll();
    }

    /**
     * 무장애 정보 동기화 (배치 내부용)
     */
    private void syncBarrierFreeInfo() {
        log.info("무장애 정보 동기화 시작");
        int pageNo = 1;

        while (true) {
            List<TourApiBarrierFreeDto> dtos = tourApiClient.fetchBarrierFreeInfo(pageNo, PAGE_SIZE);
            if (dtos.isEmpty()) break;

            updateBarrierFreeSpots(dtos);
            log.info("무장애 정보 페이지 {} 처리 완료 ({}건)", pageNo, dtos.size());

            if (dtos.size() < PAGE_SIZE) break;
            pageNo++;
        }

        log.info("무장애 정보 동기화 완료");
    }

    /**
     * 이미지 동기화 (이미지 없는 장소만 대상)
     */
    private void syncImages() {
        log.info("이미지 동기화 시작");
        List<TouristSpot> spotsWithoutImages = touristSpotRepository.findByImagesIsNullOrImagesIsEmpty();
        log.info("이미지 없는 장소 {}건 처리 예정", spotsWithoutImages.size());

        for (TouristSpot spot : spotsWithoutImages) {
            try {
                List<String> images = tourApiClient.fetchImages(spot.getContentId());
                if (!images.isEmpty()) {
                    updateSpotImages(spot.getId(), images);
                }
                Thread.sleep(100);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                log.warn("이미지 동기화 중단 (인터럽트)");
                break;
            } catch (Exception e) {
                log.error("이미지 동기화 실패 — contentId={}: {}", spot.getContentId(), e.getMessage());
            }
        }

        log.info("이미지 동기화 완료");
    }

    // ── Transactional helpers ──────────────────────────────────────

    @Transactional
    public void saveTourSpots(List<TourApiPlaceDto> dtos) {
        for (TourApiPlaceDto dto : dtos) {
            try {
                upsertTourSpot(dto);
            } catch (Exception e) {
                log.error("장소 저장 실패 — contentId={}: {}", dto.getContentid(), e.getMessage());
            }
        }
    }

    private void upsertTourSpot(TourApiPlaceDto dto) {
        String contentId = dto.getContentid();
        if (contentId == null || contentId.isBlank()) return;

        Category category = mapCategory(dto.getContenttypeid());
        Double lat = parseDouble(dto.getMapy());
        Double lng = parseDouble(dto.getMapx());
        String name = dto.getTitle() != null ? dto.getTitle() : "";

        Optional<TouristSpot> existing = touristSpotRepository.findByContentId(contentId);
        if (existing.isPresent()) {
            existing.get().update(name, dto.getAddr1(), lat, lng, category, dto.getTel(), dto.getFirstimage());
        } else {
            TouristSpot spot = TouristSpot.create(contentId, name, dto.getAddr1(),
                    lat, lng, category, dto.getTel(), dto.getFirstimage());
            touristSpotRepository.save(spot);
        }
    }

    @Transactional
    public void updateBarrierFreeSpots(List<TourApiBarrierFreeDto> dtos) {
        for (TourApiBarrierFreeDto dto : dtos) {
            try {
                Optional<TouristSpot> spotOpt = touristSpotRepository.findByContentId(dto.getContentid());
                if (spotOpt.isEmpty()) continue;

                boolean hasRamp             = "1".equals(dto.getWheelchair());
                boolean hasElevator         = "1".equals(dto.getElevator());
                boolean hasAccessibleToilet = "1".equals(dto.getRestroom());
                boolean hasRestZone         = "1".equals(dto.getRoute());
                boolean hasAccessibleParking = "1".equals(dto.getParking());

                spotOpt.get().updateBarrierFree(hasRamp, hasElevator,
                        hasAccessibleToilet, hasRestZone, hasAccessibleParking);
            } catch (Exception e) {
                log.error("무장애 정보 업데이트 실패 — contentId={}: {}", dto.getContentid(), e.getMessage());
            }
        }
    }

    @Transactional
    public void updateSpotImages(Long spotId, List<String> images) {
        touristSpotRepository.findById(spotId).ifPresent(spot -> spot.updateImages(images));
    }

    // ── Private utilities ──────────────────────────────────────────

    private Category mapCategory(String contentTypeId) {
        if (contentTypeId == null) return Category.NATURE;
        return switch (contentTypeId) {
            case "14", "15" -> Category.CULTURE;
            case "32"       -> Category.ACCOMMODATION;
            case "38"       -> Category.SHOPPING;
            case "39"       -> Category.FOOD;
            default         -> Category.NATURE;
        };
    }

    private Double parseDouble(String value) {
        if (value == null || value.isBlank()) return null;
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}

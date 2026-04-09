package com.jeju.jeju.infrastructure.tourapi;

import com.jeju.jeju.common.response.ApiResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin/sync")
public class TourApiSyncController {

    private static final Logger log = LoggerFactory.getLogger(TourApiSyncController.class);

    private final TourApiSyncService tourApiSyncService;

    public TourApiSyncController(TourApiSyncService tourApiSyncService) {
        this.tourApiSyncService = tourApiSyncService;
    }

    /**
     * POST /api/v1/admin/sync/tour
     * 관광정보 수동 동기화 트리거 — 즉시 202 반환, 백그라운드 실행
     */
    @PostMapping("/tour")
    public ResponseEntity<ApiResponse<String>> syncTour() {
        log.info("수동 동기화 요청 수신");
        new Thread(() -> {
            try {
                tourApiSyncService.syncNow();
            } catch (Exception e) {
                log.error("수동 동기화 실패: {}", e.getMessage());
            }
        }).start();

        return ResponseEntity
                .status(HttpStatus.ACCEPTED)
                .body(ApiResponse.success("동기화가 시작되었습니다."));
    }
}

package com.jeju.jeju.domain.place.controller;

import com.jeju.jeju.common.response.ApiResponse;
import com.jeju.jeju.common.response.PageResponse;
import com.jeju.jeju.domain.place.dto.AutocompleteResponse;
import com.jeju.jeju.domain.place.dto.PlaceDetailResponse;
import com.jeju.jeju.domain.place.dto.PlaceLikeResponse;
import com.jeju.jeju.domain.place.dto.PlaceSummaryResponse;
import com.jeju.jeju.domain.place.dto.RecentPlaceResponse;
import com.jeju.jeju.domain.place.service.PlaceService;
import com.jeju.jeju.security.CustomUserDetails;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/places")
public class PlaceController {

    private final PlaceService placeService;

    public PlaceController(PlaceService placeService) {
        this.placeService = placeService;
    }

    /**
     * GET /api/v1/places
     * 장소 목록 조회 (카테고리, 무장애 필터 지원). 비로그인 허용.
     */
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<PlaceSummaryResponse>>> getPlaces(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Boolean barrierFree,
            @RequestParam(required = false) Integer areaCode,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @AuthenticationPrincipal(required = false) CustomUserDetails userDetails) {
        Long userId = userDetails != null ? userDetails.getUserId() : null;
        return ResponseEntity.ok(ApiResponse.success(
                placeService.getPlaces(category, barrierFree, areaCode, page, size, userId)));
    }

    /**
     * GET /api/v1/places/search
     * 키워드 장소 검색. 비로그인 허용.
     */
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<PageResponse<PlaceSummaryResponse>>> searchPlaces(
            @RequestParam("q") String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @AuthenticationPrincipal(required = false) CustomUserDetails userDetails) {
        Long userId = userDetails != null ? userDetails.getUserId() : null;
        return ResponseEntity.ok(ApiResponse.success(
                placeService.searchPlaces(keyword, page, size, userId)));
    }

    /**
     * GET /api/v1/places/search/autocomplete
     * 장소 이름 자동완성. 비로그인 허용.
     */
    @GetMapping("/search/autocomplete")
    public ResponseEntity<ApiResponse<List<AutocompleteResponse>>> autocomplete(
            @RequestParam("q") String keyword,
            @RequestParam(defaultValue = "5") int limit,
            @AuthenticationPrincipal(required = false) CustomUserDetails userDetails) {
        return ResponseEntity.ok(ApiResponse.success(
                placeService.autocomplete(keyword, limit)));
    }

    /**
     * GET /api/v1/places/liked
     * 찜한 장소 목록 조회. 인증 필요.
     */
    @GetMapping("/liked")
    public ResponseEntity<ApiResponse<PageResponse<PlaceSummaryResponse>>> getLikedPlaces(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        return ResponseEntity.ok(ApiResponse.success(
                placeService.getLikedPlaces(userDetails.getUserId(), page, size)));
    }

    /**
     * GET /api/v1/places/recent
     * 최근 본 장소 목록 조회. 인증 필요.
     */
    @GetMapping("/recent")
    public ResponseEntity<ApiResponse<List<RecentPlaceResponse>>> getRecentPlaces(
            @RequestParam(defaultValue = "20") int limit,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        return ResponseEntity.ok(ApiResponse.success(
                placeService.getRecentPlaces(userDetails.getUserId(), limit)));
    }

    /**
     * GET /api/v1/places/{id}
     * 장소 상세 조회. 비로그인 허용.
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<PlaceDetailResponse>> getPlaceDetail(
            @PathVariable Long id,
            @AuthenticationPrincipal(required = false) CustomUserDetails userDetails) {
        Long userId = userDetails != null ? userDetails.getUserId() : null;
        return ResponseEntity.ok(ApiResponse.success(
                placeService.getPlaceDetail(id, userId)));
    }

    /**
     * POST /api/v1/places/{id}/like
     * 장소 찜하기. 인증 필요.
     */
    @PostMapping("/{id}/like")
    public ResponseEntity<ApiResponse<PlaceLikeResponse>> likePlace(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        return ResponseEntity.ok(ApiResponse.success(
                placeService.likePlace(id, userDetails.getUserId())));
    }

    /**
     * DELETE /api/v1/places/{id}/like
     * 장소 찜 취소. 인증 필요.
     */
    @DeleteMapping("/{id}/like")
    public ResponseEntity<ApiResponse<PlaceLikeResponse>> unlikePlace(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        return ResponseEntity.ok(ApiResponse.success(
                placeService.unlikePlace(id, userDetails.getUserId())));
    }
}

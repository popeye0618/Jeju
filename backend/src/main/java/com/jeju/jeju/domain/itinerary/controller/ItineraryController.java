package com.jeju.jeju.domain.itinerary.controller;

import com.jeju.jeju.common.response.ApiResponse;
import com.jeju.jeju.domain.itinerary.dto.*;
import com.jeju.jeju.domain.itinerary.service.ItineraryService;
import com.jeju.jeju.security.CustomUserDetails;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/v1/itineraries")
public class ItineraryController {

    private final ItineraryService itineraryService;

    public ItineraryController(ItineraryService itineraryService) {
        this.itineraryService = itineraryService;
    }

    @GetMapping("/recommend")
    public ApiResponse<?> recommendItineraries(
            Authentication authentication,
            @RequestParam(required = false) LocalDate date,
            @RequestParam(required = false) Boolean refresh) {
        Long userId = extractUserId(authentication);
        return ApiResponse.success(itineraryService.recommendItineraries(userId, date));
    }

    @GetMapping("/my")
    public ApiResponse<?> getMyItineraries(
            Authentication authentication,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Long userId = extractUserIdRequired(authentication);
        return ApiResponse.success(
                itineraryService.getMyItineraries(userId, page, size));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<?> createItinerary(
            Authentication authentication,
            @Valid @RequestBody ItineraryCreateRequest req) {
        Long userId = extractUserIdRequired(authentication);
        return ApiResponse.success(
                itineraryService.createItinerary(userId, req));
    }

    @GetMapping("/{id}")
    public ApiResponse<?> getItineraryDetail(
            Authentication authentication,
            @PathVariable Long id) {
        Long userId = extractUserId(authentication);
        return ApiResponse.success(itineraryService.getItineraryDetail(id, userId));
    }

    @PutMapping("/{id}")
    public ApiResponse<?> updateItinerary(
            Authentication authentication,
            @PathVariable Long id,
            @Valid @RequestBody ItineraryUpdateRequest req) {
        Long userId = extractUserIdRequired(authentication);
        return ApiResponse.success(
                itineraryService.updateItinerary(id, userId, req));
    }

    @DeleteMapping("/{id}")
    public ApiResponse<?> deleteItinerary(
            Authentication authentication,
            @PathVariable Long id) {
        Long userId = extractUserIdRequired(authentication);
        itineraryService.deleteItinerary(id, userId);
        return ApiResponse.success(null);
    }

    @PostMapping("/{id}/save")
    public ApiResponse<?> saveItinerary(
            Authentication authentication,
            @PathVariable Long id) {
        Long userId = extractUserIdRequired(authentication);
        return ApiResponse.success(
                itineraryService.saveItinerary(id, userId));
    }

    @DeleteMapping("/{id}/save")
    public ApiResponse<?> unsaveItinerary(
            Authentication authentication,
            @PathVariable Long id) {
        Long userId = extractUserIdRequired(authentication);
        return ApiResponse.success(
                itineraryService.unsaveItinerary(id, userId));
    }

    @GetMapping("/{id}/alternative")
    public ApiResponse<?> getAlternativeRoutes(
            Authentication authentication,
            @PathVariable Long id,
            @RequestParam(required = false) String reason) {
        Long userId = extractUserIdRequired(authentication);
        return ApiResponse.success(
                itineraryService.getAlternativeRoutes(id, reason, userId));
    }

    @PostMapping("/{id}/share")
    public ApiResponse<?> generateShareLink(
            Authentication authentication,
            @PathVariable Long id) {
        Long userId = extractUserIdRequired(authentication);
        return ApiResponse.success(
                itineraryService.generateShareLink(id, userId));
    }

    // ── helpers ────────────────────────────────────────────────────

    private Long extractUserId(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) return null;
        Object principal = authentication.getPrincipal();
        if (principal instanceof CustomUserDetails details) {
            return details.getUserId();
        }
        return null;
    }

    private Long extractUserIdRequired(Authentication authentication) {
        Long userId = extractUserId(authentication);
        if (userId == null) {
            throw new IllegalStateException("인증된 사용자만 접근 가능합니다.");
        }
        return userId;
    }
}

package com.jeju.jeju.domain.report.controller;

import com.jeju.jeju.common.response.ApiResponse;
import com.jeju.jeju.domain.report.dto.ReportCreateRequest;
import com.jeju.jeju.domain.report.dto.ReportCreateResponse;
import com.jeju.jeju.domain.report.service.ReportService;
import com.jeju.jeju.security.CustomUserDetails;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/reports")
public class ReportController {

    private final ReportService reportService;

    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    /**
     * POST /api/v1/reports
     * 신고 접수. 인증 필요.
     */
    @PostMapping
    public ResponseEntity<ApiResponse<ReportCreateResponse>> createReport(
            @Valid @RequestBody ReportCreateRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        ReportCreateResponse response = reportService.createReport(userDetails.getUserId(), request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response));
    }
}

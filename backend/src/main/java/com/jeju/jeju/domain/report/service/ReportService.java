package com.jeju.jeju.domain.report.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.report.dto.ReportCreateRequest;
import com.jeju.jeju.domain.report.dto.ReportCreateResponse;
import com.jeju.jeju.domain.report.entity.Report;
import com.jeju.jeju.domain.report.repository.ReportRepository;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class ReportService {

    private final ReportRepository reportRepository;
    private final UserRepository userRepository;

    public ReportService(ReportRepository reportRepository, UserRepository userRepository) {
        this.reportRepository = reportRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public ReportCreateResponse createReport(Long userId, ReportCreateRequest req) {
        Report.TargetType targetType;
        try {
            targetType = Report.TargetType.valueOf(req.getTargetType().toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new BusinessException(ErrorCode.COMMON_001);
        }

        if (reportRepository.existsByUserIdAndTargetTypeAndTargetId(userId, targetType, req.getTargetId())) {
            throw new BusinessException(ErrorCode.REPORT_001);
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_002));

        String reason = req.getReason() != null ? req.getReason() : req.getDescription();
        Report report = new Report(user, targetType, req.getTargetId(), reason);
        Report saved = reportRepository.save(report);

        return new ReportCreateResponse(saved.getId(), "PENDING");
    }
}

package com.jeju.jeju.domain.report.service;

import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import com.jeju.jeju.domain.report.dto.ReportCreateRequest;
import com.jeju.jeju.domain.report.dto.ReportCreateResponse;
import com.jeju.jeju.domain.report.entity.Report;
import com.jeju.jeju.domain.report.repository.ReportRepository;
import com.jeju.jeju.domain.user.entity.User;
import com.jeju.jeju.domain.user.repository.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.mock;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ReportServiceTest {

    @InjectMocks
    private ReportService reportService;

    @Mock private ReportRepository reportRepository;
    @Mock private UserRepository userRepository;

    private User mockUser() {
        User user = mock(User.class);
        given(user.getId()).willReturn(1L);
        return user;
    }

    private Report mockReport(Long id) {
        Report report = mock(Report.class);
        given(report.getId()).willReturn(id);
        return report;
    }

    @Test
    @DisplayName("신고 접수 - 정상 (201)")
    void createReport_success() {
        User user = mockUser();
        Report report = mockReport(1L);

        given(reportRepository.existsByUserIdAndTargetTypeAndTargetId(1L, Report.TargetType.PLACE, 10L))
                .willReturn(false);
        given(userRepository.findById(1L)).willReturn(Optional.of(user));
        given(reportRepository.save(any())).willReturn(report);

        ReportCreateRequest req = new ReportCreateRequest("PLACE", 10L, "불법 정보", null, null);
        ReportCreateResponse response = reportService.createReport(1L, req);

        assertThat(response).isNotNull();
        assertThat(response.reportId()).isEqualTo(1L);
        assertThat(response.status()).isEqualTo("PENDING");
    }

    @Test
    @DisplayName("신고 접수 - 중복 신고 (REPORT_001)")
    void createReport_duplicate_throwsReport001() {
        given(reportRepository.existsByUserIdAndTargetTypeAndTargetId(1L, Report.TargetType.PLACE, 10L))
                .willReturn(true);

        ReportCreateRequest req = new ReportCreateRequest("PLACE", 10L, "불법 정보", null, null);

        assertThatThrownBy(() -> reportService.createReport(1L, req))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.REPORT_001));
    }

    @Test
    @DisplayName("신고 접수 - 잘못된 targetType (COMMON_001)")
    void createReport_invalidTargetType_throwsCommon001() {
        ReportCreateRequest req = new ReportCreateRequest("INVALID", 10L, "불법 정보", null, null);

        assertThatThrownBy(() -> reportService.createReport(1L, req))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.COMMON_001));
    }
}

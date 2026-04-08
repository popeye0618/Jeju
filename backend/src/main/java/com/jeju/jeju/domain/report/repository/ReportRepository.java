package com.jeju.jeju.domain.report.repository;

import com.jeju.jeju.domain.report.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReportRepository extends JpaRepository<Report, Long> {

    boolean existsByUserIdAndTargetTypeAndTargetId(Long userId, Report.TargetType targetType, Long targetId);
}

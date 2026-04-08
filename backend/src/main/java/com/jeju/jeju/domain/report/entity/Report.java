package com.jeju.jeju.domain.report.entity;

import com.jeju.jeju.domain.user.entity.User;
import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(
    name = "reports",
    uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "target_type", "target_id"})
)
@EntityListeners(AuditingEntityListener.class)
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TargetType targetType;

    @Column(nullable = false)
    private Long targetId;

    @Column(columnDefinition = "TEXT")
    private String reason;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    protected Report() {}

    public Report(User user, TargetType targetType, Long targetId, String reason) {
        this.user = user;
        this.targetType = targetType;
        this.targetId = targetId;
        this.reason = reason;
    }

    public Long getId()                  { return id; }
    public User getUser()                { return user; }
    public TargetType getTargetType()    { return targetType; }
    public Long getTargetId()            { return targetId; }
    public String getReason()            { return reason; }
    public LocalDateTime getCreatedAt()  { return createdAt; }

    public enum TargetType { REVIEW, PLACE }
}

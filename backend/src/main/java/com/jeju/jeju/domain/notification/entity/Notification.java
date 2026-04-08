package com.jeju.jeju.domain.notification.entity;

import com.jeju.jeju.domain.user.entity.User;
import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(name = "notifications")
@EntityListeners(AuditingEntityListener.class)
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private NotificationType type;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String body;

    @Column(nullable = false)
    private boolean isRead = false;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    protected Notification() {}

    public Notification(User user, NotificationType type, String title, String body) {
        this.user = user;
        this.type = type;
        this.title = title;
        this.body = body;
    }

    public void markAsRead() {
        this.isRead = true;
    }

    public Long getId()                  { return id; }
    public User getUser()                { return user; }
    public NotificationType getType()    { return type; }
    public String getTitle()             { return title; }
    public String getBody()              { return body; }
    public boolean isRead()              { return isRead; }
    public LocalDateTime getCreatedAt()  { return createdAt; }

    public enum NotificationType { WEATHER_ALERT, ITINERARY_SAVED, REVIEW_COMMENT, SYSTEM }
}

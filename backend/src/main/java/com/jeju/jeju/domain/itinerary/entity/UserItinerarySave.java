package com.jeju.jeju.domain.itinerary.entity;

import com.jeju.jeju.domain.user.entity.User;
import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(
    name = "user_itinerary_saves",
    uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "itinerary_id"})
)
@EntityListeners(AuditingEntityListener.class)
public class UserItinerarySave {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "itinerary_id", nullable = false)
    private Itinerary itinerary;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    protected UserItinerarySave() {}

    public UserItinerarySave(User user, Itinerary itinerary) {
        this.user = user;
        this.itinerary = itinerary;
    }

    public Long getId()                 { return id; }
    public User getUser()               { return user; }
    public Itinerary getItinerary()     { return itinerary; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}

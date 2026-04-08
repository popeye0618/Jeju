package com.jeju.jeju.domain.place.entity;

import com.jeju.jeju.domain.user.entity.User;
import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(
    name = "user_place_likes",
    uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "tourist_spot_id"})
)
@EntityListeners(AuditingEntityListener.class)
public class UserPlaceLike {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tourist_spot_id", nullable = false)
    private TouristSpot touristSpot;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    protected UserPlaceLike() {}

    public UserPlaceLike(User user, TouristSpot touristSpot) {
        this.user = user;
        this.touristSpot = touristSpot;
    }

    public Long getId()              { return id; }
    public User getUser()            { return user; }
    public TouristSpot getTouristSpot() { return touristSpot; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}

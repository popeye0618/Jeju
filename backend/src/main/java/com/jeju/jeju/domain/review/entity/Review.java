package com.jeju.jeju.domain.review.entity;

import com.jeju.jeju.domain.place.entity.StringListConverter;
import com.jeju.jeju.domain.place.entity.TouristSpot;
import com.jeju.jeju.domain.user.entity.User;
import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(
    name = "reviews",
    uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "tourist_spot_id"})
)
@EntityListeners(AuditingEntityListener.class)
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tourist_spot_id", nullable = false)
    private TouristSpot touristSpot;

    @Column(nullable = false)
    private int rating;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(columnDefinition = "JSON")
    @Convert(converter = StringListConverter.class)
    private List<String> imageUrls;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    protected Review() {}

    public Review(User user, TouristSpot touristSpot, int rating, String content, List<String> imageUrls) {
        this.user = user;
        this.touristSpot = touristSpot;
        this.rating = rating;
        this.content = content;
        this.imageUrls = imageUrls;
    }

    public Long getId()                  { return id; }
    public User getUser()                { return user; }
    public TouristSpot getTouristSpot()  { return touristSpot; }
    public int getRating()               { return rating; }
    public String getContent()           { return content; }
    public List<String> getImageUrls()   { return imageUrls; }
    public LocalDateTime getCreatedAt()  { return createdAt; }

    public boolean isOwner(Long userId) {
        return this.user.getId().equals(userId);
    }
}

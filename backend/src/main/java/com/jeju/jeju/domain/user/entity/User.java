package com.jeju.jeju.domain.user.entity;

import com.jeju.jeju.common.entity.BaseTimeEntity;
import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    private String password;

    @Column(nullable = false)
    private String nickname;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Provider provider;

    private String providerId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role = Role.USER;

    @Column(nullable = false)
    private boolean emailVerified = false;

    @Column(nullable = false)
    private boolean onboardingComplete = false;

    @Enumerated(EnumType.STRING)
    private Companion companion;

    @Enumerated(EnumType.STRING)
    private Preference preference;

    @Enumerated(EnumType.STRING)
    private Mobility mobility;

    private Integer travelDays;

    @Column(nullable = false)
    private boolean termsAgreed = false;

    @Column(nullable = false)
    private boolean privacyAgreed = false;

    @Enumerated(EnumType.STRING)
    private WithdrawReason withdrawReason;

    // ── 생성자 ─────────────────────────────────────

    protected User() {}

    public static User ofEmail(String email, String encodedPassword, String nickname) {
        User user = new User();
        user.email = email;
        user.password = encodedPassword;
        user.nickname = nickname;
        user.provider = Provider.EMAIL;
        return user;
    }

    public static User ofSocial(String email, String nickname, Provider provider, String providerId) {
        User user = new User();
        user.email = email;
        user.nickname = nickname;
        user.provider = provider;
        user.providerId = providerId;
        user.emailVerified = true;
        return user;
    }

    // ── 도메인 메서드 ────────────────────────────────

    public void verifyEmail() {
        this.emailVerified = true;
    }

    public void completeOnboarding(Companion companion, Preference preference,
                                   Mobility mobility, int travelDays, String nickname,
                                   boolean termsAgreed, boolean privacyAgreed) {
        this.companion = companion;
        this.preference = preference;
        this.mobility = mobility;
        this.travelDays = travelDays;
        this.nickname = nickname;
        this.termsAgreed = termsAgreed;
        this.privacyAgreed = privacyAgreed;
        this.onboardingComplete = true;
    }

    public void updateProfile(String nickname, Companion companion, Preference preference, Mobility mobility) {
        if (nickname != null)    this.nickname = nickname;
        if (companion != null)   this.companion = companion;
        if (preference != null)  this.preference = preference;
        if (mobility != null)    this.mobility = mobility;
    }

    public void changePassword(String encodedPassword) {
        this.password = encodedPassword;
    }

    public void withdraw(WithdrawReason reason) {
        this.withdrawReason = reason;
    }

    // ── Getter ─────────────────────────────────────

    public Long getId()                     { return id; }
    public String getEmail()                { return email; }
    public String getPassword()             { return password; }
    public String getNickname()             { return nickname; }
    public Provider getProvider()           { return provider; }
    public String getProviderId()           { return providerId; }
    public Role getRole()                   { return role; }
    public boolean isEmailVerified()        { return emailVerified; }
    public boolean isOnboardingComplete()   { return onboardingComplete; }
    public Companion getCompanion()         { return companion; }
    public Preference getPreference()       { return preference; }
    public Mobility getMobility()           { return mobility; }
    public Integer getTravelDays()          { return travelDays; }
    public boolean isTermsAgreed()          { return termsAgreed; }
    public boolean isPrivacyAgreed()        { return privacyAgreed; }
    public WithdrawReason getWithdrawReason() { return withdrawReason; }

    // ── Enum ──────────────────────────────────────

    public enum Provider      { EMAIL, KAKAO, GOOGLE }
    public enum Role          { USER, ADMIN }
    public enum Companion     { SOLO, COUPLE, FAMILY, FRIENDS }
    public enum Preference    { INDOOR, OUTDOOR, BOTH }
    public enum Mobility      { WHEELCHAIR, STROLLER, ELDERLY, NORMAL }
    public enum WithdrawReason { LACK_OF_CONTENT, PRIVACY_CONCERN, DUPLICATE_ACCOUNT, OTHER }
}

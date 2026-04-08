package com.jeju.jeju.domain.user.dto;

import com.jeju.jeju.domain.user.entity.User;

public class ProfileUpdateRequest {

    private String nickname;
    private User.Companion companion;
    private User.Preference preference;
    private User.Mobility mobility;

    public ProfileUpdateRequest() {}

    public ProfileUpdateRequest(String nickname, User.Companion companion,
                                User.Preference preference, User.Mobility mobility) {
        this.nickname = nickname;
        this.companion = companion;
        this.preference = preference;
        this.mobility = mobility;
    }

    public String getNickname()           { return nickname; }
    public User.Companion getCompanion()  { return companion; }
    public User.Preference getPreference(){ return preference; }
    public User.Mobility getMobility()    { return mobility; }
}

package com.jeju.jeju.domain.user.dto;

public class SocialLoginResponse {

    private String accessToken;
    private String refreshToken;
    private String tokenType;
    private long expiresIn;
    private boolean isNewUser;

    public SocialLoginResponse() {}

    public SocialLoginResponse(String accessToken, String refreshToken, String tokenType,
                                long expiresIn, boolean isNewUser) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        this.tokenType = tokenType;
        this.expiresIn = expiresIn;
        this.isNewUser = isNewUser;
    }

    public String getAccessToken()  { return accessToken; }
    public String getRefreshToken() { return refreshToken; }
    public String getTokenType()    { return tokenType; }
    public long getExpiresIn()      { return expiresIn; }
    public boolean isNewUser()      { return isNewUser; }
}

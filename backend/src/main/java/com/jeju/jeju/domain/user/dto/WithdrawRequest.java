package com.jeju.jeju.domain.user.dto;

public class WithdrawRequest {

    private String reason;

    public WithdrawRequest() {}

    public WithdrawRequest(String reason) {
        this.reason = reason;
    }

    public String getReason() { return reason; }
}

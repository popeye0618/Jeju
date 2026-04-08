package com.jeju.jeju.common.exception;

import org.springframework.http.HttpStatus;

public enum ErrorCode {

    // ── Common ────────────────────────────────────
    COMMON_001(HttpStatus.BAD_REQUEST,          "COMMON_001", "유효하지 않은 입력값입니다."),
    COMMON_002(HttpStatus.INTERNAL_SERVER_ERROR,"COMMON_002", "서버 내부 오류가 발생했습니다."),

    // ── Auth ──────────────────────────────────────
    AUTH_001(HttpStatus.UNAUTHORIZED, "AUTH_001", "이메일 또는 비밀번호가 올바르지 않습니다."),
    AUTH_002(HttpStatus.UNAUTHORIZED, "AUTH_002", "이메일 인증이 완료되지 않았습니다."),
    AUTH_003(HttpStatus.UNAUTHORIZED, "AUTH_003", "Access Token이 만료되었거나 유효하지 않습니다."),
    AUTH_004(HttpStatus.UNAUTHORIZED, "AUTH_004", "Refresh Token이 만료되었습니다. 다시 로그인해주세요."),
    AUTH_005(HttpStatus.BAD_REQUEST,  "AUTH_005", "소셜 로그인에 실패했습니다."),

    // ── User ──────────────────────────────────────
    USER_001(HttpStatus.CONFLICT,  "USER_001", "이미 사용 중인 닉네임입니다."),
    USER_002(HttpStatus.NOT_FOUND, "USER_002", "존재하지 않는 사용자입니다."),

    // ── Itinerary ────────────────────────────────
    ITIN_001(HttpStatus.NOT_FOUND,  "ITIN_001", "존재하지 않는 일정입니다."),
    ITIN_002(HttpStatus.FORBIDDEN,  "ITIN_002", "타인의 일정에 접근할 수 없습니다."),

    // ── Place ─────────────────────────────────────
    PLACE_001(HttpStatus.NOT_FOUND,        "PLACE_001", "존재하지 않는 장소입니다."),
    PLACE_002(HttpStatus.BAD_GATEWAY,      "PLACE_002", "한국관광공사 API 조회에 실패했습니다."),

    // ── Review ────────────────────────────────────
    REVIEW_001(HttpStatus.CONFLICT, "REVIEW_001", "이미 작성한 후기가 있습니다."),

    // ── Report ────────────────────────────────────
    REPORT_001(HttpStatus.CONFLICT, "REPORT_001", "이미 신고한 대상입니다.");

    private final HttpStatus httpStatus;
    private final String code;
    private final String message;

    ErrorCode(HttpStatus httpStatus, String code, String message) {
        this.httpStatus = httpStatus;
        this.code = code;
        this.message = message;
    }

    public HttpStatus getHttpStatus() { return httpStatus; }
    public String getCode()           { return code; }
    public String getMessage()        { return message; }
}

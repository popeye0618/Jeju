package com.jeju.jeju.common.response;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {

    private final boolean success;
    private final String code;
    private final String message;
    private final T data;
    private final Object errors;

    private ApiResponse(boolean success, String code, String message, T data, Object errors) {
        this.success = success;
        this.code = code;
        this.message = message;
        this.data = data;
        this.errors = errors;
    }

    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "SUCCESS", "요청이 성공적으로 처리되었습니다.", data, null);
    }

    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(true, "SUCCESS", message, data, null);
    }

    public static <T> ApiResponse<T> error(String code, String message) {
        return new ApiResponse<>(false, code, message, null, null);
    }

    public static <T> ApiResponse<T> error(String code, String message, Object errors) {
        return new ApiResponse<>(false, code, message, null, errors);
    }

    public boolean isSuccess()  { return success; }
    public String getCode()     { return code; }
    public String getMessage()  { return message; }
    public T getData()          { return data; }
    public Object getErrors()   { return errors; }
}

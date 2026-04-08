package com.jeju.jeju.domain.report.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;

public class ReportCreateRequest {

    @NotBlank
    private String targetType;

    @NotNull
    private Long targetId;

    private String reason;

    @Size(max = 500)
    private String description;

    @Size(max = 3)
    private List<String> imageUrls;

    public ReportCreateRequest() {}

    public ReportCreateRequest(String targetType, Long targetId, String reason,
                               String description, List<String> imageUrls) {
        this.targetType = targetType;
        this.targetId = targetId;
        this.reason = reason;
        this.description = description;
        this.imageUrls = imageUrls;
    }

    public String getTargetType()      { return targetType; }
    public Long getTargetId()          { return targetId; }
    public String getReason()          { return reason; }
    public String getDescription()     { return description; }
    public List<String> getImageUrls() { return imageUrls; }
}

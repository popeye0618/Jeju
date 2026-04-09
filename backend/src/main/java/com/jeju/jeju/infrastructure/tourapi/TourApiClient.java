package com.jeju.jeju.infrastructure.tourapi;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jeju.jeju.common.exception.BusinessException;
import com.jeju.jeju.common.exception.ErrorCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class TourApiClient {

    private static final Logger log = LoggerFactory.getLogger(TourApiClient.class);

    private static final String KOR_SERVICE_PATH    = "/KorService2";
    private static final String KOR_WITH_PATH       = "/KorWithService2";
    private static final String MOBILE_OS           = "ETC";
    private static final String MOBILE_APP          = "JejuApp";
    private static final String AREA_CODE_JEJU      = "39";

    @Value("${tour.api.kor-service-key:}")
    private String korServiceKey;

    @Value("${tour.api.kor-with-service-key:}")
    private String korWithServiceKey;

    @Value("${tour.api.base-url:https://apis.data.go.kr/B551011}")
    private String baseUrl;

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public TourApiClient() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    /**
     * KorService2/areaBasedList2 — 지역 기반 관광정보 목록 조회
     */
    @SuppressWarnings("unchecked")
    public List<TourApiPlaceDto> fetchTourPlaces(int pageNo, int numOfRows) {
        try {
            String url = UriComponentsBuilder
                    .fromUriString(baseUrl + KOR_SERVICE_PATH + "/areaBasedList2")
                    .queryParam("serviceKey", korServiceKey)
                    .queryParam("areaCode", AREA_CODE_JEJU)
                    .queryParam("MobileOS", MOBILE_OS)
                    .queryParam("MobileApp", MOBILE_APP)
                    .queryParam("_type", "json")
                    .queryParam("pageNo", pageNo)
                    .queryParam("numOfRows", numOfRows)
                    .build(false)
                    .toUriString();

            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            return parseItems(response, TourApiPlaceDto.class);
        } catch (RestClientException e) {
            log.error("관광정보 목록 조회 실패 — pageNo={}, numOfRows={}: {}", pageNo, numOfRows, e.getMessage());
            throw new BusinessException(ErrorCode.PLACE_002);
        }
    }

    /**
     * KorService2/areaBasedList2 — 전체 레코드 수 조회
     */
    @SuppressWarnings("unchecked")
    public int fetchTotalCount() {
        try {
            String url = UriComponentsBuilder
                    .fromUriString(baseUrl + KOR_SERVICE_PATH + "/areaBasedList2")
                    .queryParam("serviceKey", korServiceKey)
                    .queryParam("areaCode", AREA_CODE_JEJU)
                    .queryParam("MobileOS", MOBILE_OS)
                    .queryParam("MobileApp", MOBILE_APP)
                    .queryParam("_type", "json")
                    .queryParam("pageNo", 1)
                    .queryParam("numOfRows", 1)
                    .build(false)
                    .toUriString();

            Map<String, Object> raw = restTemplate.getForObject(url, Map.class);
            if (raw == null) return 0;

            Map<String, Object> response = (Map<String, Object>) raw.get("response");
            if (response == null) return 0;
            Map<String, Object> body = (Map<String, Object>) response.get("body");
            if (body == null) return 0;

            Object totalCount = body.get("totalCount");
            if (totalCount == null) return 0;
            return Integer.parseInt(String.valueOf(totalCount));
        } catch (Exception e) {
            log.error("totalCount 조회 실패: {}", e.getMessage());
            return 0;
        }
    }

    /**
     * KorService2/detailImage2 — 이미지 목록 조회
     */
    @SuppressWarnings("unchecked")
    public List<String> fetchImages(String contentId) {
        try {
            String url = UriComponentsBuilder
                    .fromUriString(baseUrl + KOR_SERVICE_PATH + "/detailImage2")
                    .queryParam("serviceKey", korServiceKey)
                    .queryParam("contentId", contentId)
                    .queryParam("MobileOS", MOBILE_OS)
                    .queryParam("MobileApp", MOBILE_APP)
                    .queryParam("_type", "json")
                    .queryParam("imageYN", "Y")
                    .build(false)
                    .toUriString();

            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            List<Map<String, Object>> items = parseRawItems(response);
            return items.stream()
                    .map(item -> (String) item.get("originimgurl"))
                    .filter(url2 -> url2 != null && !url2.isBlank())
                    .collect(Collectors.toList());
        } catch (Exception e) {
            log.warn("이미지 조회 실패 — contentId={}: {}", contentId, e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * KorWithService2/areaBasedList2 — 무장애 여행 정보 목록 조회
     */
    @SuppressWarnings("unchecked")
    public List<TourApiBarrierFreeDto> fetchBarrierFreeInfo(int pageNo, int numOfRows) {
        try {
            String url = UriComponentsBuilder
                    .fromUriString(baseUrl + KOR_WITH_PATH + "/areaBasedList2")
                    .queryParam("serviceKey", korWithServiceKey)
                    .queryParam("areaCode", AREA_CODE_JEJU)
                    .queryParam("MobileOS", MOBILE_OS)
                    .queryParam("MobileApp", MOBILE_APP)
                    .queryParam("_type", "json")
                    .queryParam("pageNo", pageNo)
                    .queryParam("numOfRows", numOfRows)
                    .build(false)
                    .toUriString();

            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            return parseItems(response, TourApiBarrierFreeDto.class);
        } catch (Exception e) {
            log.error("무장애 정보 조회 실패 — pageNo={}: {}", pageNo, e.getMessage());
            return Collections.emptyList();
        }
    }

    // ── Private helpers ────────────────────────────────────────────

    @SuppressWarnings("unchecked")
    private <T> List<T> parseItems(Map<String, Object> raw, Class<T> dtoClass) {
        List<Map<String, Object>> rawItems = parseRawItems(raw);
        return rawItems.stream()
                .map(item -> objectMapper.convertValue(item, dtoClass))
                .collect(Collectors.toList());
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> parseRawItems(Map<String, Object> raw) {
        if (raw == null) return Collections.emptyList();

        Object responseObj = raw.get("response");
        if (!(responseObj instanceof Map)) return Collections.emptyList();
        Map<String, Object> response = (Map<String, Object>) responseObj;

        Object bodyObj = response.get("body");
        if (!(bodyObj instanceof Map)) return Collections.emptyList();
        Map<String, Object> body = (Map<String, Object>) bodyObj;

        Object itemsObj = body.get("items");
        if (!(itemsObj instanceof Map)) return Collections.emptyList();
        Map<String, Object> items = (Map<String, Object>) itemsObj;

        Object itemObj = items.get("item");
        if (itemObj == null) return Collections.emptyList();

        if (itemObj instanceof List) {
            return (List<Map<String, Object>>) itemObj;
        } else if (itemObj instanceof Map) {
            return Collections.singletonList((Map<String, Object>) itemObj);
        }

        return Collections.emptyList();
    }
}

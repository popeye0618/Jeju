-- ================================================
-- 같이가는 제주 DB 스키마 (MySQL 8.0)
-- Docker Compose 초기화 시 자동 실행
-- ================================================

CREATE DATABASE IF NOT EXISTS jeju CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE jeju;

-- ── 사용자 ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    email               VARCHAR(255)                         NOT NULL UNIQUE,
    password            VARCHAR(255)                         NULL COMMENT '이메일 가입 시에만 존재',
    nickname            VARCHAR(100)                         NOT NULL,
    provider            ENUM('EMAIL','KAKAO','GOOGLE')       NOT NULL,
    provider_id         VARCHAR(255)                         NULL COMMENT '소셜 로그인 시에만 존재',
    role                ENUM('USER','ADMIN')                 NOT NULL DEFAULT 'USER',
    email_verified      BOOLEAN                              NOT NULL DEFAULT FALSE,
    onboarding_complete BOOLEAN                              NOT NULL DEFAULT FALSE,
    companion           ENUM('SOLO','COUPLE','FAMILY','FRIENDS') NULL,
    preference          ENUM('INDOOR','OUTDOOR','BOTH')      NULL,
    mobility            ENUM('WHEELCHAIR','STROLLER','ELDERLY','NORMAL') NULL,
    travel_days         TINYINT                              NULL COMMENT '희망 여행 일수 (1~5)',
    terms_agreed        BOOLEAN                              NOT NULL DEFAULT FALSE,
    privacy_agreed      BOOLEAN                              NOT NULL DEFAULT FALSE,
    withdraw_reason     ENUM('LACK_OF_CONTENT','PRIVACY_CONCERN','DUPLICATE_ACCOUNT','OTHER') NULL,
    created_at          DATETIME                             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME                             NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 관광지 ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS tourist_spots (
    id                      BIGINT AUTO_INCREMENT PRIMARY KEY,
    content_id              VARCHAR(50)   NOT NULL UNIQUE COMMENT '한국관광공사 콘텐츠 ID',
    name                    VARCHAR(255)  NOT NULL,
    address                 VARCHAR(500)  NULL,
    lat                     DECIMAL(10,7) NULL COMMENT '위도',
    lng                     DECIMAL(10,7) NULL COMMENT '경도',
    category                ENUM('NATURE','FOOD','ACCOMMODATION','CULTURE','SHOPPING') NOT NULL,
    tel                     VARCHAR(50)   NULL,
    open_time               VARCHAR(10)   NULL COMMENT '예: 09:00',
    close_time              VARCHAR(10)   NULL COMMENT '예: 18:00',
    has_ramp                BOOLEAN       NOT NULL DEFAULT FALSE,
    has_elevator            BOOLEAN       NOT NULL DEFAULT FALSE,
    has_accessible_toilet   BOOLEAN       NOT NULL DEFAULT FALSE,
    has_rest_zone           BOOLEAN       NOT NULL DEFAULT FALSE,
    has_accessible_parking  BOOLEAN       NOT NULL DEFAULT FALSE,
    accessibility_score     TINYINT       NOT NULL DEFAULT 0 COMMENT '무장애 점수 (0~100)',
    thumbnail               TEXT          NULL,
    images                  JSON          NULL COMMENT '이미지 URL 배열',
    created_at              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_location (lat, lng)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 일정 ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS itineraries (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id             BIGINT        NOT NULL,
    title               VARCHAR(255)  NOT NULL,
    thumbnail           TEXT          NULL,
    type                ENUM('RECOMMENDED','CUSTOM') NOT NULL DEFAULT 'CUSTOM',
    trip_days           TINYINT       NOT NULL DEFAULT 1,
    accessibility_score TINYINT       NULL COMMENT '무장애 접근성 점수 (0~100)',
    share_token         VARCHAR(64)   NULL UNIQUE COMMENT '공유 링크 UUID',
    share_expires_at    DATETIME      NULL,
    created_at          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 동선 (일정의 Day별 코스) ──────────────────────
CREATE TABLE IF NOT EXISTS routes (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    itinerary_id        BIGINT         NOT NULL,
    day_number          TINYINT        NOT NULL COMMENT 'n일차',
    total_distance_km   DECIMAL(6,2)   NULL,
    route_score         DECIMAL(5,2)   NULL,
    risk_level          ENUM('SAFE','CAUTION','DANGER') NOT NULL DEFAULT 'SAFE',
    FOREIGN KEY (itinerary_id) REFERENCES itineraries(id) ON DELETE CASCADE,
    INDEX idx_itinerary_id (itinerary_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 동선 장소 (방문 순서) ─────────────────────────
CREATE TABLE IF NOT EXISTS route_places (
    id                    BIGINT AUTO_INCREMENT PRIMARY KEY,
    route_id              BIGINT   NOT NULL,
    tourist_spot_id       BIGINT   NOT NULL,
    visit_order           TINYINT  NOT NULL COMMENT '방문 순서',
    stay_minutes          SMALLINT NULL COMMENT '예상 체류 시간(분)',
    travel_to_next_min    SMALLINT NULL COMMENT '다음 장소까지 이동 시간(분)',
    reason                TEXT     NULL COMMENT '추천 이유',
    FOREIGN KEY (route_id) REFERENCES routes(id) ON DELETE CASCADE,
    FOREIGN KEY (tourist_spot_id) REFERENCES tourist_spots(id),
    INDEX idx_route_id (route_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 대체 코스 ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS alternative_routes (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    original_route_id   BIGINT NOT NULL,
    trigger_reason      ENUM('WEATHER','ACCESSIBILITY','PREFERENCE') NULL,
    alt_route_json      JSON   NULL COMMENT '대체 코스 전체 데이터',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (original_route_id) REFERENCES routes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 일정 저장 ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS user_itinerary_saves (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT   NOT NULL,
    itinerary_id    BIGINT   NOT NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_user_itinerary (user_id, itinerary_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (itinerary_id) REFERENCES itineraries(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 장소 찜 ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS user_place_likes (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT   NOT NULL,
    tourist_spot_id BIGINT   NOT NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_user_place (user_id, tourist_spot_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (tourist_spot_id) REFERENCES tourist_spots(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 후기 ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reviews (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT        NOT NULL,
    tourist_spot_id BIGINT        NOT NULL,
    rating          TINYINT       NOT NULL COMMENT '1~5',
    content         TEXT          NOT NULL,
    image_urls      JSON          NULL COMMENT '이미지 URL 배열',
    created_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_user_spot_review (user_id, tourist_spot_id) COMMENT '중복 후기 방지',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (tourist_spot_id) REFERENCES tourist_spots(id) ON DELETE CASCADE,
    INDEX idx_spot_id (tourist_spot_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 알림 ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notifications (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT        NOT NULL,
    type        ENUM('WEATHER_ALERT','ITINERARY_SAVED','REVIEW_COMMENT','SYSTEM') NOT NULL,
    title       VARCHAR(255)  NOT NULL,
    body        TEXT          NOT NULL,
    is_read     BOOLEAN       NOT NULL DEFAULT FALSE,
    created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── 신고 / 정보 정정 ─────────────────────────────
CREATE TABLE IF NOT EXISTS reports (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT        NOT NULL,
    target_type     ENUM('REVIEW','PLACE') NOT NULL,
    target_id       BIGINT        NOT NULL,
    reason          TEXT          NULL,
    created_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_user_target (user_id, target_type, target_id) COMMENT '중복 신고 방지',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_target (target_type, target_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

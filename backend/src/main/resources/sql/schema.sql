-- ================================================
-- 같이가는 제주 DB 스키마 (MySQL 8.0)
-- Docker Compose 초기화 시 자동 실행
-- ================================================

CREATE DATABASE IF NOT EXISTS jeju CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE jeju;

-- 사용자
CREATE TABLE IF NOT EXISTS users (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    email       VARCHAR(255) NOT NULL UNIQUE,
    nickname    VARCHAR(100) NOT NULL,
    provider    ENUM('KAKAO', 'GOOGLE') NOT NULL,
    provider_id VARCHAR(255) NOT NULL,
    role        ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 관광지
CREATE TABLE IF NOT EXISTS tourist_spots (
    id                   BIGINT AUTO_INCREMENT PRIMARY KEY,
    content_id           VARCHAR(50) NOT NULL UNIQUE COMMENT '관광공사 콘텐츠 ID',
    title                VARCHAR(255) NOT NULL,
    address              VARCHAR(500),
    lat                  DECIMAL(10, 7) COMMENT '위도',
    lng                  DECIMAL(10, 7) COMMENT '경도',
    category             ENUM('TOURIST', 'RESTAURANT', 'CAFE', 'ACCOMMODATION', 'EVENT') NOT NULL,
    has_ramp             BOOLEAN DEFAULT FALSE COMMENT '경사로',
    has_elevator         BOOLEAN DEFAULT FALSE COMMENT '엘리베이터',
    has_wheelchair_toilet BOOLEAN DEFAULT FALSE COMMENT '휠체어 화장실',
    has_rest_area        BOOLEAN DEFAULT FALSE COMMENT '휴식공간',
    is_indoor            BOOLEAN DEFAULT NULL COMMENT '실내여부 (null=혼합)',
    image_url            TEXT,
    description          TEXT,
    phone                VARCHAR(50),
    operating_hours      VARCHAR(500),
    accessibility_score  TINYINT DEFAULT 0 COMMENT '무장애 점수 (0~4)',
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_location (lat, lng)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 여행 일정
CREATE TABLE IF NOT EXISTS itineraries (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id       BIGINT NOT NULL,
    title         VARCHAR(255) NOT NULL,
    traveler_type ENUM('WHEELCHAIR', 'ELDERLY', 'STROLLER', 'GENERAL') NOT NULL,
    env_pref      ENUM('INDOOR', 'OUTDOOR', 'MIXED') NOT NULL,
    mobility_level ENUM('LOW', 'MED', 'HIGH') NOT NULL,
    trip_days     TINYINT NOT NULL,
    status        ENUM('DRAFT', 'SAVED') NOT NULL DEFAULT 'DRAFT',
    safety_score  TINYINT COMMENT '전체 안전 점수 (0~100)',
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 동선 (일정의 Day별 코스)
CREATE TABLE IF NOT EXISTS routes (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    itinerary_id        BIGINT NOT NULL,
    day_number          TINYINT NOT NULL COMMENT 'n일차',
    total_distance_km   DECIMAL(6, 2),
    route_score         DECIMAL(5, 2) COMMENT '동선 적합도 점수',
    risk_level          ENUM('SAFE', 'CAUTION', 'DANGER') NOT NULL DEFAULT 'SAFE',
    FOREIGN KEY (itinerary_id) REFERENCES itineraries(id) ON DELETE CASCADE,
    INDEX idx_itinerary_id (itinerary_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 동선 장소 (방문 순서)
CREATE TABLE IF NOT EXISTS route_places (
    id                   BIGINT AUTO_INCREMENT PRIMARY KEY,
    route_id             BIGINT NOT NULL,
    tourist_spot_id      BIGINT NOT NULL,
    visit_order          TINYINT NOT NULL COMMENT '방문 순서',
    stay_minutes         SMALLINT COMMENT '예상 체류 시간(분)',
    travel_to_next_min   SMALLINT COMMENT '다음 장소까지 이동 시간(분)',
    reason               TEXT COMMENT '이 장소가 추천된 이유 (설명 가능한 추천)',
    FOREIGN KEY (route_id) REFERENCES routes(id) ON DELETE CASCADE,
    FOREIGN KEY (tourist_spot_id) REFERENCES tourist_spots(id),
    INDEX idx_route_id (route_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 대체 코스
CREATE TABLE IF NOT EXISTS alternative_routes (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    original_route_id BIGINT NOT NULL,
    trigger_reason  TEXT COMMENT '대체 코스 생성 이유',
    alt_route_json  JSON COMMENT '대체 코스 전체 데이터 (JSON)',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (original_route_id) REFERENCES routes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

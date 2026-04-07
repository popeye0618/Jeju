# CLAUDE.md

## Project Overview

**같이가는 제주** — 무장애 여행 일정 설계 서비스 (2026 한국관광공사 공모전)

- **Backend:** Spring Boot 4.0.5 · Java 21 · Gradle 9.4.1
- **Frontend:** Flutter 3.19+ · Riverpod · Dio
- Base package: `com.jeju.jeju`

## Build Commands

### Backend
```bash
./gradlew bootRun          # 실행
./gradlew build            # 빌드
./gradlew test             # 전체 테스트
./gradlew clean build      # 클린 빌드
```

### Frontend
```bash
flutter pub get            # 의존성 설치
flutter run                # 실행 (에뮬레이터/기기)
flutter build apk          # Android 빌드
flutter build ios          # iOS 빌드
flutter test               # 테스트
```

## Tech Stack

| 영역 | 기술 |
|------|------|
| Security | Spring Security, OAuth2 (Kakao·Google), JWT |
| Data | Spring Data JPA, H2 (dev), MySQL (prod) |
| Cache | Redis |
| State | Riverpod |
| Network | Dio |

## Database

- Dev: H2 in-memory (H2 console 활성화)
- Prod: MySQL
- Config: `backend/src/main/resources/application.yml`

## API Specification

> 백엔드 작업 시 `backend/CLAUDE.md` 참조

- Notion 명세: https://www.notion.so/33bd2cd2348c819e82d6d4049878824b
- OpenAPI: `docs/api/openapi.yaml`
- Base URL: `http://localhost:8080` / `https://api.jeju.app`
- Prefix: `/api/v1`

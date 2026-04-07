# JWT 인증 기능 구현 - GitHub Issue 생성 및 Git 브랜치 전략

## 1. GitHub Issue 생성

다음 명령으로 GitHub Issue를 생성한다.

```bash
gh issue create \
  --title "feat: JWT 인증 기능 구현" \
  --label "feature,backend,priority:high" \
  --body "$(cat <<'EOF'
## 개요

Spring Security 기반의 JWT 인증 기능을 구현한다.

## 작업 내용

- [ ] `SecurityConfig` 필터 체인 설정 (JWT 필터 등록, 세션 비활성화 등)
- [ ] `JwtAuthenticationFilter` 클래스 구현 (요청 헤더에서 토큰 추출 및 인증 처리)
- [ ] `TokenProvider` 클래스 구현 (JWT 토큰 발급 및 검증 로직)

## 기술 스택

- Spring Security
- JWT (jjwt 또는 java-jwt 라이브러리)
- Java 21 / Spring Boot 4.0.5

## 구현 상세

### SecurityConfig
- `SecurityFilterChain` 빈 등록
- `JwtAuthenticationFilter`를 `UsernamePasswordAuthenticationFilter` 앞에 추가
- 세션 정책: `STATELESS`
- CSRF 비활성화

### JwtAuthenticationFilter
- `OncePerRequestFilter` 상속
- Authorization 헤더에서 Bearer 토큰 추출
- `TokenProvider`로 토큰 검증 후 `SecurityContext`에 인증 정보 저장

### TokenProvider
- 액세스 토큰 발급 (`generateToken`)
- 토큰 검증 (`validateToken`)
- 토큰에서 Claims 추출 (`getClaims`)
- 토큰에서 사용자 정보 추출 (`getAuthentication`)

## 우선순위

높음 (High)

## 관련 파일

- `src/main/java/com/jeju/jeju/security/SecurityConfig.java`
- `src/main/java/com/jeju/jeju/security/JwtAuthenticationFilter.java`
- `src/main/java/com/jeju/jeju/security/TokenProvider.java`
EOF
)"
```

## 2. Git 브랜치 전략

### 브랜치 생성

Issue 번호가 생성된 후 (예: #42) 다음 명령으로 브랜치를 만든다.

```bash
# main 브랜치에서 최신 상태로 시작
git checkout main
git pull origin main

# feature 브랜치 생성 및 체크아웃
git checkout -b feature/jwt-authentication
```

브랜치 네이밍 컨벤션: `feature/jwt-authentication` 또는 이슈 번호를 포함한 `feature/42-jwt-authentication`

### 작업 흐름

```bash
# 1. 작업 진행 중 커밋
git add src/main/java/com/jeju/jeju/security/TokenProvider.java
git commit -m "feat: TokenProvider - JWT 토큰 발급 및 검증 로직 구현"

git add src/main/java/com/jeju/jeju/security/JwtAuthenticationFilter.java
git commit -m "feat: JwtAuthenticationFilter - 요청 헤더 토큰 추출 및 인증 처리"

git add src/main/java/com/jeju/jeju/security/SecurityConfig.java
git commit -m "feat: SecurityConfig - JWT 필터 체인 설정"

# 2. 원격 브랜치에 푸시
git push -u origin feature/jwt-authentication

# 3. Pull Request 생성 (작업 완료 후)
gh pr create \
  --title "feat: JWT 인증 기능 구현 (#42)" \
  --base main \
  --head feature/jwt-authentication \
  --body "Closes #42

## 변경 사항
- SecurityConfig 필터 체인 설정
- JwtAuthenticationFilter 구현
- TokenProvider 구현 (발급/검증)"
```

## 3. 요약

| 항목 | 내용 |
|------|------|
| Issue 제목 | `feat: JWT 인증 기능 구현` |
| 라벨 | `feature`, `backend`, `priority:high` |
| 브랜치명 | `feature/jwt-authentication` |
| 베이스 브랜치 | `main` |
| 커밋 단위 | 클래스별 (TokenProvider → Filter → SecurityConfig) |
| PR 연결 | `Closes #<이슈번호>` 본문 포함 |

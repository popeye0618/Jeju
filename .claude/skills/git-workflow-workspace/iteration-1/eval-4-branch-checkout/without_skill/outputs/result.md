# 소셜 로그인 기능 추가 - Git Workflow 도움말

## 상황 분석

- 기능: OAuth2 기반 소셜 로그인 (구글, 카카오)
- 작업 범위: 백엔드(Spring Security OAuth2) + 프론트엔드
- 현재 브랜치: main

---

## 1. GitHub Issue 생성 명령 (실행하지 말 것)

```bash
gh issue create \
  --title "소셜 로그인 기능 추가 (구글, 카카오 OAuth2)" \
  --body "## 개요
OAuth2를 활용한 소셜 로그인 기능을 구현합니다.

## 작업 항목
### 백엔드
- [ ] Spring Security OAuth2 Client 설정
- [ ] Google OAuth2 로그인 구현
- [ ] Kakao OAuth2 로그인 구현
- [ ] OAuth2 사용자 정보 처리 (UserDetailsService 연동)
- [ ] JWT 토큰 발급 연동

### 프론트엔드
- [ ] 구글 로그인 버튼 UI 구현
- [ ] 카카오 로그인 버튼 UI 구현
- [ ] OAuth2 콜백 처리 페이지
- [ ] 로그인 상태 관리

## 관련 설정
- application.yml에 OAuth2 클라이언트 ID/Secret 추가 필요
- Google Cloud Console, Kakao Developers 앱 등록 필요" \
  --label "feature,auth,oauth2"
```

---

## 2. 브랜치 이름 추천

소셜 로그인 기능의 특성(OAuth2, 구글+카카오, 백엔드+프론트)을 고려한 추천 목록:

### 추천 1 (최우선 추천)
```
feature/social-login
```
- 간결하고 명확, 업계 표준 네이밍
- 구글/카카오 등 공급자 확장 시에도 유효한 이름

### 추천 2
```
feature/oauth2-social-login
```
- 기술 스택(OAuth2)과 기능을 동시에 표현
- 다른 인증 방식과 구분 명확

### 추천 3
```
feature/oauth2-google-kakao
```
- 구현 대상 명시적 표현
- 특정 공급자에 한정된 느낌

### 추천 4
```
feature/social-auth
```
- 짧고 간결

**권장 선택: `feature/social-login`**

---

## 3. 브랜치 생성 명령 (실행하지 말 것)

```bash
# main 브랜치 기준으로 새 브랜치 생성
git checkout -b feature/social-login main

# 또는 현재 브랜치에서 분기
git checkout -b feature/social-login

# 원격 저장소에 푸시 (추후)
git push -u origin feature/social-login
```

---

## 요약

| 항목 | 내용 |
|------|------|
| 추천 브랜치명 | `feature/social-login` |
| 기준 브랜치 | `main` |
| Issue 제목 | 소셜 로그인 기능 추가 (구글, 카카오 OAuth2) |
| 예상 작업 범위 | 백엔드 OAuth2 설정 + 프론트엔드 UI/콜백 처리 |

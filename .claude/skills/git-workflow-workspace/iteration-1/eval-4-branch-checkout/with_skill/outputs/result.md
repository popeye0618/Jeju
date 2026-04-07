# 소셜 로그인 기능 추가 - Git 워크플로우 결과

---

## 1. Issue 생성 명령

작업 분석:
- **type**: `feat` (새 기능 구현)
- **stack**: `fullstack` (백엔드 Spring Boot + 프론트엔드 Flutter 모두 작업)
- **priority**: `high` (로그인은 핵심 인증 기능)

```bash
gh issue create \
  --title "[FEAT] OAuth2 소셜 로그인 구현 (Google, Kakao)" \
  --body "$(cat <<'EOF'
## 📋 설명
OAuth2 프로토콜을 사용해 Google과 Kakao 소셜 로그인을 구현한다.
백엔드(Spring Boot)에서 OAuth2 인증 서버 설정과 토큰 처리를 담당하고,
프론트엔드(Flutter)에서 소셜 로그인 UI 및 플로우를 구현한다.

## 🎯 목표
- [ ] Spring Security OAuth2 Client 설정
- [ ] Google OAuth2 로그인 구현
- [ ] Kakao OAuth2 로그인 구현
- [ ] Flutter 소셜 로그인 UI 구현
- [ ] 소셜 로그인 후 JWT 토큰 발급 및 처리

## 📝 상세 내용

### Backend (Spring)
- `application.yml`에 Google/Kakao OAuth2 클라이언트 설정 추가
- `SecurityConfig.java`에 OAuth2 로그인 설정 구성
- `CustomOAuth2UserService` 구현 (Google, Kakao 사용자 정보 처리)
- OAuth2 인증 성공 핸들러 구현 (JWT 토큰 발급)
- 소셜 로그인 사용자 Entity/Dto 설계 (provider, providerId 필드 추가)

### Frontend (Flutter)
- Google Sign-In 패키지 연동
- Kakao SDK 연동
- 소셜 로그인 버튼 UI 구현
- 로그인 성공 후 JWT 토큰 저장 및 인증 상태 관리

### 공통
- 소셜 로그인 공통 응답 스펙 정의
- 에러 처리 (로그인 취소, 인증 실패 등)

## 🔗 관련 이슈/PR
- 없음

## ✅ 완료 조건
- [ ] 코드 작성 완료
- [ ] 단위 테스트 작성
- [ ] 통합 테스트 수행
- [ ] Code Review 완료
- [ ] 문서 업데이트

## 📚 참고 자료
- [Spring Security OAuth2](https://docs.spring.io/spring-security/reference/servlet/oauth2/index.html)
- [Kakao Developers - REST API 가이드](https://developers.kakao.com/docs/latest/ko/kakaologin/rest-api)
EOF
)" \
  --label "type/feature,stack/fullstack,priority/high"
```

> 위 명령 실행 후 CLI가 출력하는 Issue 번호(예: #42)를 브랜치명에 활용한다.

---

## 2. 제안 브랜치명

Issue 번호가 생성된 후 아래 형식으로 브랜치명을 제안합니다.

Issue 번호를 `{N}`으로 가정한 예시:

```
feature/{N}-oauth2-social-login
```

실제 Issue 번호가 예를 들어 **42**라면:

```
feature/42-oauth2-social-login
```

**브랜치명 선택 근거:**
- type: `feature` — 새 기능 추가이므로 `feature` 브랜치 사용
- base: `dev` — 일반 기능이므로 `dev` 브랜치에서 파생
- description: `oauth2-social-login` — OAuth2 소셜 로그인을 명확히 표현, snake-case 적용

---

## 3. 사용자 확인 요청 문구

> 브랜치명으로 **`feature/42-oauth2-social-login`** 을 제안합니다.
>
> - 베이스 브랜치: `dev`
> - 작업 범위: OAuth2 설정 및 Google/Kakao 소셜 로그인 (백엔드 + 프론트)
>
> 이 브랜치명으로 생성할까요? 원하시면 "좋아"라고 답해 주세요.
> (브랜치명을 수정하고 싶으시면 원하는 이름을 알려 주세요.)

---

## 4. 브랜치 생성 / 체크아웃 명령

사용자가 "좋아"로 확인한 후 실행할 명령 (Issue 번호 42 예시):

```bash
# dev 브랜치로 이동 후 최신화
git checkout dev && git pull origin dev

# 새 브랜치 생성 및 체크아웃
git checkout -b feature/42-oauth2-social-login

# 현재 브랜치 확인
git branch --show-current
```

**예상 출력:**
```
feature/42-oauth2-social-login
```

브랜치 생성 완료 후 사용자에게 안내:
> `feature/42-oauth2-social-login` 브랜치가 생성되었습니다. 이제 소셜 로그인 작업을 시작할 수 있습니다.

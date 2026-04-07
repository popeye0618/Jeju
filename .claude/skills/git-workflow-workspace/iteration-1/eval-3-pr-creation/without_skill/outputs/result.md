# PR 생성 명령 (without skill)

## 상황 분석

- 브랜치: `feature/42-jwt-auth`
- 이슈 번호: `#42`
- 작업 유형: `feat` (새로운 기능 - JWT 인증)
- 범위: `security` (보안 관련)
- 병합 대상: `dev` (브랜치 전략상 feature → dev)

---

## gh CLI 전체 명령

```bash
gh pr create \
  --base dev \
  --head feature/42-jwt-auth \
  --title "[feat/security] JWT 인증 시스템 구현" \
  --body "$(cat <<'EOF'
## 📌 관련 이슈
Closes #42

## 🎯 변경 사항 요약
JWT(JSON Web Token) 기반 인증 시스템을 구현했습니다.
사용자 로그인 시 JWT 토큰을 발급하고, 이후 요청에서 토큰을 검증하여 인증을 처리합니다.

## 🔄 변경 사항 상세

### Backend
- `JwtTokenProvider`: JWT 토큰 생성, 파싱, 검증 유틸 클래스 구현
- `JwtAuthenticationFilter`: 요청마다 JWT 토큰을 검증하는 Security Filter 추가
- `SecurityConfig`: JwtAuthenticationFilter를 Security Filter Chain에 등록
- `AuthController`: 로그인/회원가입 엔드포인트 구현
- `AuthService`: 인증 비즈니스 로직 구현
- 유효하지 않은 토큰에 대한 예외 처리 (`JwtException`)

### Frontend
- 해당 없음

### 기타
- `application.yml`: JWT secret key, token 만료 시간 설정 추가

## ✅ 테스트 완료
- [ ] 단위 테스트 작성 및 통과
- [ ] 통합 테스트 수행
- [ ] 로컬 테스트 완료
- [ ] 성능 테스트 (필요시)

## 📸 스크린샷 (UI 변경 시)
해당 없음 (백엔드 전용 변경)

## 📝 체크리스트
- [ ] 코드 리뷰 가이드라인 준수
- [ ] 문서 업데이트 완료
- [ ] Conventional Commits 준수
- [ ] 불필요한 콘솔 로그 제거
- [ ] 보안 취약점 검토

## 🔗 참고 자료
- [Spring Security JWT 공식 문서](https://spring.io/projects/spring-security)
- [JJWT 라이브러리](https://github.com/jwtk/jjwt)
EOF
)"
```

---

## PR Body 단독 내용

```markdown
## 📌 관련 이슈
Closes #42

## 🎯 변경 사항 요약
JWT(JSON Web Token) 기반 인증 시스템을 구현했습니다.
사용자 로그인 시 JWT 토큰을 발급하고, 이후 요청에서 토큰을 검증하여 인증을 처리합니다.

## 🔄 변경 사항 상세

### Backend
- `JwtTokenProvider`: JWT 토큰 생성, 파싱, 검증 유틸 클래스 구현
- `JwtAuthenticationFilter`: 요청마다 JWT 토큰을 검증하는 Security Filter 추가
- `SecurityConfig`: JwtAuthenticationFilter를 Security Filter Chain에 등록
- `AuthController`: 로그인/회원가입 엔드포인트 구현
- `AuthService`: 인증 비즈니스 로직 구현
- 유효하지 않은 토큰에 대한 예외 처리 (`JwtException`)

### Frontend
- 해당 없음

### 기타
- `application.yml`: JWT secret key, token 만료 시간 설정 추가

## ✅ 테스트 완료
- [ ] 단위 테스트 작성 및 통과
- [ ] 통합 테스트 수행
- [ ] 로컬 테스트 완료
- [ ] 성능 테스트 (필요시)

## 📸 스크린샷 (UI 변경 시)
해당 없음 (백엔드 전용 변경)

## 📝 체크리스트
- [ ] 코드 리뷰 가이드라인 준수
- [ ] 문서 업데이트 완료
- [ ] Conventional Commits 준수
- [ ] 불필요한 콘솔 로그 제거
- [ ] 보안 취약점 검토

## 🔗 참고 자료
- [Spring Security JWT 공식 문서](https://spring.io/projects/spring-security)
- [JJWT 라이브러리](https://github.com/jwtk/jjwt)
```

---

## 판단 근거

| 항목 | 선택 값 | 근거 |
|------|---------|------|
| PR 제목 형식 | `[feat/security]` | memo.txt의 PR 제목 형식 `[TYPE/SCOPE]` 준수 |
| base 브랜치 | `dev` | feature 브랜치는 dev로 병합 (브랜치 전략) |
| 이슈 번호 | `#42` | 브랜치명 `feature/42-jwt-auth`에서 추출 |
| scope | `security` | JWT 인증은 보안 관련 변경 (`security` scope) |

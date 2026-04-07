# JWT 인증 기능 구현 - Issue 생성 및 브랜치 제안

## gh issue create 명령 (전체 body 포함)

```bash
gh issue create \
  --title "[feat] JWT 인증 기능 구현" \
  --body "$(cat <<'EOF'
## 📋 설명
JWT(JSON Web Token) 기반 인증 기능을 구현한다.
SecurityConfig에서 필터 체인을 설정하고, JwtAuthenticationFilter와 TokenProvider 클래스를 통해 토큰 발급 및 검증 로직을 처리한다.

## 🎯 목표
- [ ] SecurityConfig에 JWT 필터 체인 설정
- [ ] JwtAuthenticationFilter 클래스 구현
- [ ] TokenProvider 클래스 구현 (토큰 발급/검증 로직)

## 📝 상세 내용

### Backend (Spring)
- `SecurityConfig.java`: `JwtAuthenticationFilter`를 Spring Security 필터 체인에 등록, stateless 세션 정책 설정
- `JwtAuthenticationFilter.java`: HTTP 요청에서 JWT 토큰을 추출하고 인증 처리하는 필터 구현
- `TokenProvider.java`: JWT 토큰 생성(발급), 파싱, 유효성 검증 로직 구현

## 🔗 관련 이슈/PR
- 없음

## ✅ 완료 조건
- [ ] 코드 작성 완료
- [ ] 단위 테스트 작성
- [ ] 통합 테스트 수행
- [ ] Code Review 완료
- [ ] 문서 업데이트

## 📚 참고 자료
- Spring Security JWT 공식 문서
- io.jsonwebtoken (jjwt) 라이브러리
EOF
)" \
  --label "type/feature,stack/backend,priority/high"
```

---

## 제안 브랜치명

Issue 생성 후 CLI가 출력하는 Issue 번호를 확인한 뒤 아래 형식으로 브랜치를 생성한다.
(예시: Issue 번호가 42인 경우)

```
feature/42-jwt-authentication
```

---

## 브랜치 생성 명령

```bash
# dev 브랜치에서 파생 (일반 feature 작업)
git checkout dev && git pull origin dev
git checkout -b feature/42-jwt-authentication

# 브랜치 생성 확인
git branch --show-current
```

> 주의: `42` 부분은 실제 gh issue create 실행 후 출력된 Issue 번호로 교체해야 한다.

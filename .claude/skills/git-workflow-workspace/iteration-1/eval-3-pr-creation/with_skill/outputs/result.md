# PR 생성 명령

## 브랜치 정보
- 현재 브랜치: `feature/42-jwt-auth`
- 이슈 번호: #42
- base 브랜치: `dev` (feature 브랜치는 dev로 병합)

## gh pr create 전체 명령

```bash
gh pr create \
  --title "[feat/security] JWT 인증 구현" \
  --body "$(cat <<'EOF'
## 📌 관련 이슈
Closes #42

## 🎯 변경 사항 요약
JWT 기반 인증 시스템을 구현했다. 기존 세션 기반 인증을 대체하여 stateless 인증을 가능하게 한다.

## 🔄 변경 사항 상세

### Backend
- JwtAuthenticationFilter 추가: 요청마다 JWT 토큰을 검증하는 필터 구현
- TokenProvider 추가: JWT 토큰 발급 및 검증 로직 분리
- SecurityConfig 수정: JwtAuthenticationFilter를 Spring Security 필터 체인에 등록
- JWT 관련 예외 처리 추가 (만료, 유효하지 않은 토큰 등)

### Frontend
- 해당 없음

### 기타
- 해당 없음

## ✅ 테스트 완료
- [ ] 단위 테스트 작성 및 통과
- [ ] 통합 테스트 수행
- [ ] 로컬 테스트 완료
- [ ] 성능 테스트 (필요시)

## 📸 스크린샷 (UI 변경 시)
해당 없음

## 📝 체크리스트
- [ ] 코드 리뷰 가이드라인 준수
- [ ] 문서 업데이트 완료
- [ ] Conventional Commits 준수
- [ ] 불필요한 콘솔 로그 제거
- [ ] 보안 취약점 검토

## 🔗 참고 자료
- 해당 없음
EOF
)" \
  --base dev
```

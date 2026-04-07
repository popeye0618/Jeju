# 커밋 메시지 작성 결과

## 분석

수정된 파일:
- `SecurityConfig.java` - Spring Security 설정 (보안 필터 체인, 접근 제어 규칙 등)
- `JwtAuthenticationFilter.java` - JWT 토큰 기반 인증 필터
- `TokenProvider.java` - JWT 토큰 생성/검증 유틸리티

이 세 파일은 JWT 기반 인증/인가 시스템의 핵심 구성요소입니다.

---

## 커밋 메시지 (Conventional Commits 형식)

```
feat(security): JWT 인증 필터 및 토큰 처리 로직 개선 (#42)

- SecurityConfig에서 JWT 필터 체인 설정 업데이트
- JwtAuthenticationFilter에서 토큰 추출 및 인증 처리 개선
- TokenProvider에서 토큰 생성/검증 로직 수정

Closes #42
```

---

## 커밋 명령어

```bash
git add src/main/java/com/jeju/jeju/security/SecurityConfig.java \
        src/main/java/com/jeju/jeju/security/JwtAuthenticationFilter.java \
        src/main/java/com/jeju/jeju/security/TokenProvider.java

git commit -m "feat(security): JWT 인증 필터 및 토큰 처리 로직 개선 (#42)

- SecurityConfig에서 JWT 필터 체인 설정 업데이트
- JwtAuthenticationFilter에서 토큰 추출 및 인증 처리 개선
- TokenProvider에서 토큰 생성/검증 로직 수정

Closes #42"
```

---

## 참고: Conventional Commits 형식 설명

| 요소 | 값 | 설명 |
|------|-----|------|
| type | `feat` | 새 기능 또는 기존 기능 개선 (보안 기능 변경) |
| scope | `security` | 변경 범위 (security 패키지) |
| subject | 한글 요약 | 변경 내용 한 줄 요약 |
| issue reference | `(#42)` | 제목에 이슈 번호 포함 |
| body | 불릿 리스트 | 파일별 변경 내용 상세 설명 |
| footer | `Closes #42` | GitHub 이슈 자동 닫기 |

> **참고:** 파일들이 버그 수정이라면 `feat` 대신 `fix`를 사용하세요.
> 실제 변경 내용에 따라 type을 조정하는 것이 좋습니다.

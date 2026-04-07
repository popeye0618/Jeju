# 커밋 메시지 생성 결과

## 파일 분석

| 파일 | scope 매핑 |
|------|-----------|
| `SecurityConfig.java` | `security` |
| `JwtAuthenticationFilter.java` | `security` (`*Filter.java`) |
| `TokenProvider.java` | `security` (`*Provider.java`) |

세 파일 모두 `security` scope에 해당.

---

## 생성된 커밋 메시지

```
refactor(security): JWT 인증 구성 리팩토링

SecurityConfig에서 JWT 필터 체인을 재구성하고,
JwtAuthenticationFilter의 인증 처리 흐름을 개선했다.
TokenProvider를 통해 토큰 발급 및 검증 로직을 분리해
책임 범위를 명확히 했다.

Closes #42
```

### 구성 요소

| 항목 | 값 |
|------|----|
| type | `refactor` |
| scope | `security` |
| subject | `JWT 인증 구성 리팩토링` |
| body | SecurityConfig에서 JWT 필터 체인을 재구성하고, JwtAuthenticationFilter의 인증 처리 흐름을 개선했다. TokenProvider를 통해 토큰 발급 및 검증 로직을 분리해 책임 범위를 명확히 했다. |
| footer | `Closes #42` |

---

## git commit 명령

```bash
git add src/main/java/com/jeju/jeju/security/SecurityConfig.java \
        src/main/java/com/jeju/jeju/security/JwtAuthenticationFilter.java \
        src/main/java/com/jeju/jeju/security/TokenProvider.java
git commit -m "$(cat <<'EOF'
refactor(security): JWT 인증 구성 리팩토링

SecurityConfig에서 JWT 필터 체인을 재구성하고,
JwtAuthenticationFilter의 인증 처리 흐름을 개선했다.
TokenProvider를 통해 토큰 발급 및 검증 로직을 분리해
책임 범위를 명확히 했다.

Closes #42
EOF
)"
```

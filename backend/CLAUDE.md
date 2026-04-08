# Backend CLAUDE.md

## API Response Structure

모든 응답은 아래 wrapper를 **반드시** 사용. Controller에서 직접 객체 반환 금지.

```json
{ "success": true, "code": "SUCCESS", "message": "...", "data": {} }
```

페이지네이션 data:
```json
{ "content": [], "page": 0, "size": 20, "totalElements": 100, "totalPages": 5, "hasNext": true }
```

에러:
```json
{ "success": false, "code": "AUTH_001", "message": "...", "data": null, "errors": [...] }
```
> `errors`: Bean Validation 실패 시만 포함, 그 외 null

## HTTP Status Rules

| Status | 용도 |
|--------|------|
| 200 | 조회·수정·삭제 성공 |
| 201 | 리소스 생성 |
| 400 | Bean Validation 실패 (COMMON_001) |
| 401 | 인증 오류 (AUTH_001~004) |
| 403 | 권한 없음 (ITIN_002) |
| 404 | 리소스 없음 (USER_002, ITIN_001, PLACE_001) |
| 409 | 중복 (USER_001, REVIEW_001, REPORT_001) |
| 500 | 서버 오류 (COMMON_002) |
| 502 | 외부 API 오류 (PLACE_002) |

## Error Codes

| 코드 | 설명 |
|------|------|
| COMMON_001 | 유효하지 않은 입력값 |
| COMMON_002 | 서버 내부 오류 |
| AUTH_001 | 이메일/비밀번호 불일치 |
| AUTH_002 | 이메일 미인증 |
| AUTH_003 | Access Token 만료/무효 |
| AUTH_004 | Refresh Token 만료 → 재로그인 |
| AUTH_005 | 소셜 로그인 실패 |
| USER_001 | 닉네임 중복 |
| USER_002 | 존재하지 않는 사용자 |
| ITIN_001 | 존재하지 않는 일정 |
| ITIN_002 | 타인 일정 접근 불가 |
| PLACE_001 | 존재하지 않는 장소 |
| PLACE_002 | 한국관광공사 API 조회 실패 |
| REVIEW_001 | 이미 작성한 후기 |
| REPORT_001 | 이미 신고한 대상 |

## Auth

- JWT Bearer Token (`Authorization: Bearer {accessToken}`)
- Access Token: 900초 (15분)
- Refresh Token: 604800초 (7일)
- 소셜: Kakao OAuth2, Google OAuth2

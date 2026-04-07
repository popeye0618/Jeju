# Git 컨벤션 상세 (Jeju 프로젝트)

## Issue 제목 형식

```
[TYPE] 작업 제목

TYPE: feat | fix | refactor | test | docs | chore
```

## Issue 라벨 전체 목록

```
타입:     type/feature | type/bugfix | type/refactor | type/test | type/docs | type/chore
스택:     stack/backend | stack/frontend | stack/fullstack
우선순위: priority/critical | priority/high | priority/medium | priority/low
상태:     status/in-progress | status/review | status/blocked
```

## Conventional Commits type 전체 목록

| type | 사용 시점 |
|------|-----------|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `refactor` | 코드 리팩토링 (기능 변화 없음) |
| `test` | 테스트 코드 추가/수정 |
| `docs` | 문서 작성/수정 |
| `style` | 코드 포맷팅 (세미콜론, 들여쓰기 등) |
| `chore` | 빌드, 의존성, 설정 변경 |
| `perf` | 성능 개선 |
| `ci` | CI/CD 설정 변경 |

## Scope 전체 목록

### Backend (Spring)
| scope | 해당 파일/계층 |
|-------|--------------|
| `controller` | `*Controller.java` |
| `service` | `*Service.java` |
| `repository` | `*Repository.java` |
| `entity` | `*Entity.java`, `*Dto.java` |
| `security` | `SecurityConfig.java`, `*Filter.java`, `*Provider.java` |
| `exception` | `*Exception.java`, `*Handler.java` |
| `config` | `*Config.java` (security 제외) |
| `util` | `*Util.java`, `*Helper.java` |
| `jpa` | JPA 쿼리/설정 관련 |

### Frontend (Flutter)
| scope | 해당 파일 |
|-------|----------|
| `ui` | `*_screen.dart`, `*_page.dart`, `*_widget.dart` |
| `provider` | `*_provider.dart`, `*_notifier.dart` |
| `service` | `*_service.dart` |
| `model` | `*_model.dart` |
| `navigation` | `*router*.dart`, `*navigation*.dart` |
| `asset` | 이미지, 폰트 등 에셋 |

### 공통
| scope | 해당 내용 |
|-------|----------|
| `config` | 공통 설정 |
| `test` | 통합 테스트 |

## 커밋 메시지 예제

### feat (Backend)
```
feat(controller): 사용자 프로필 조회 API 추가

클라이언트에서 사용자 정보를 가져올 수 있도록
GET /api/users/{id} 엔드포인트를 구현했다.

Closes #15
```

### fix (Backend)
```
fix(repository): N+1 쿼리 문제 해결

사용자 조회 시 주문 정보를 fetch join으로 로드하도록 수정.
이전: 사용자 1명 + 주문 N번 = N+1 쿼리
이후: LEFT JOIN으로 1번의 쿼리로 통합

Fixes #31
```

### feat (Frontend)
```
feat(ui): 로그인 화면 UI 구현

이메일/비밀번호 입력 폼과 소셜 로그인 버튼을 추가했다.
디자인 시안 피그마 링크 참조.

Closes #22
```

### refactor
```
refactor(service): 주문 처리 로직 Strategy 패턴 적용

복잡한 조건문을 Strategy 패턴으로 리팩토링하여 가독성 향상.
기존 동작은 변하지 않음.

Relates to #18
```

### test
```
test(provider): 사용자 프로필 Provider 단위 테스트 추가

- 성공 케이스: 데이터 정상 로드
- 실패 케이스: API 오류 처리
- 캐싱 케이스: 동일 요청 시 캐시 사용 확인

Relates to #15
```

### chore
```
chore(config): Redis 캐시 설정 추가

로컬 개발 환경에서 Redis 연결 설정과
기본 캐시 TTL 값을 application.yml에 추가했다.
```

## PR 제목 형식

```
[TYPE/SCOPE] 작업 설명

예:
[feat/backend] JWT 인증 시스템 구현
[fix/frontend] 로그인 화면 상태 관리 버그 수정
[refactor/jpa] N+1 쿼리 최적화
[feat/fullstack] 회원가입 기능 구현
```

## Best Practices

- **커밋 크기**: 하나의 논리적 단위. 파일이 많아도 같은 목적이면 하나의 커밋 OK
- **커밋 빈도**: 적어도 하루에 한 번 push
- **PR 크기**: 가능하면 하나의 PR = 하나의 Issue
- **브랜치 수명**: 1~2주 이내 병합 권장, 장기 방치 금지
- **hotfix**: 긴급 버그만 해당. main → hotfix 브랜치 → PR to main → merge to dev도 필수

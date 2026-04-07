---
name: git-workflow
description: |
  Jeju 프로젝트의 Git 워크플로우 자동화 스킬. `gh` CLI를 통해 GitHub Issue/PR을 직접 생성하고,
  Conventional Commits 형식의 커밋 메시지를 만들고, Git Flow 기반 브랜치 전략을 제안한다.

  다음 상황에서 반드시 이 스킬을 사용하라:
  - 사용자가 새 기능, 버그 수정, 리팩토링 등 **새로운 작업 계획을 설명**할 때 → Issue 생성 + 브랜치 제안
  - 사용자가 **커밋하려고 할 때** ("커밋할게", "커밋 메시지 작성해줘", 변경 파일 목록을 보여줄 때) → 커밋 메시지 생성
  - 사용자가 **PR을 만들려고 할 때** ("PR 올려줘", "PR 작성해줘") → PR 생성
  - 사용자가 **브랜치 이름을 물어볼 때** → 컨벤션에 맞는 브랜치명 제안
  - 사용자가 커밋 메시지의 컨벤션 준수 여부를 확인하고 싶을 때 → 검증 및 수정 제안

  명시적으로 요청하지 않아도, 작업 계획이나 커밋/PR 관련 맥락이 보이면 적극적으로 이 스킬을 활용하라.
---

# Git 워크플로우 자동화 (Jeju 프로젝트 전용)

이 스킬은 Spring Boot(backend) + Flutter(frontend) 풀스택 프로젝트인 Jeju의 Git 작업 일관성을 위한 도구다.
컨벤션 상세 내용은 `references/conventions.md`를 참조하라.

---

## 1단계: 작업 계획 → Issue 생성 + 브랜치 제안

사용자가 새 작업을 설명하면 이 흐름을 따른다.

### Issue 생성 절차

1. 작업 내용을 분석해 **type**을 결정 (`feat` / `fix` / `refactor` / `test` / `docs` / `chore`)
2. **stack**을 결정 (`backend` / `frontend` / `fullstack`)
3. **priority**를 문맥에서 판단 (`critical` / `high` / `medium` / `low`)
4. Issue Body를 채운 뒤 `gh issue create`로 GitHub에 직접 생성

```bash
gh issue create \
  --title "[TYPE] 작업 제목" \
  --body "$(cat <<'EOF'
## 📋 설명
(이 작업이 무엇을 해결하거나 구현하는지)

## 🎯 목표
- [ ] 목표 1
- [ ] 목표 2

## 📝 상세 내용

### Backend (Spring)
- (해당 없으면 생략)

### Frontend (Flutter)
- (해당 없으면 생략)

### 공통
- (해당 없으면 생략)

## 🔗 관련 이슈/PR
- 없음

## ✅ 완료 조건
- [ ] 코드 작성 완료
- [ ] 단위 테스트 작성
- [ ] 통합 테스트 수행
- [ ] Code Review 완료
- [ ] 문서 업데이트

## 📚 참고 자료
- (없으면 생략)
EOF
)" \
  --label "type/feature,stack/backend,priority/medium"
```

> Issue 생성 후 CLI가 출력하는 **Issue 번호**를 다음 단계(브랜치명)에 활용한다.

### 브랜치명 제안 및 생성

Issue 번호를 받아 아래 형식으로 제안:

```
{type}/{issue-number}-{snake-case-description}

예: feature/42-jwt-token-validation
    bugfix/57-null-pointer-on-login
    hotfix/103-critical-auth-bypass
```

브랜치명을 제안한 뒤 **반드시 사용자 확인을 받고** 나서 실행한다.
확인을 받으면 아래 명령으로 브랜치를 생성하고 체크아웃한다:

```bash
# 일반 작업 (feature, bugfix, refactor, test, docs): dev에서 파생
git checkout dev && git pull origin dev
git checkout -b feature/42-jwt-token-validation

# 긴급 버그 (hotfix): main에서 파생
git checkout main && git pull origin main
git checkout -b hotfix/103-critical-auth-bypass
```

브랜치 생성 후 현재 브랜치를 `git branch --show-current`로 확인하고 사용자에게 알린다.

---

## 2단계: 작업 중 → 커밋 메시지 생성

사용자가 커밋할 준비가 됐다고 하거나, 변경된 파일 목록을 보여주면 이 흐름을 따른다.

### 파일 경로 → scope 자동 매핑

| 파일 패턴 | scope |
|-----------|-------|
| `*Controller.java` | `controller` |
| `*Service.java` | `service` |
| `*Repository.java` | `repository` |
| `*Entity.java`, `*Dto.java` | `entity` |
| `SecurityConfig.java`, `*Filter.java`, `*Provider.java` | `security` |
| `*Exception.java`, `*Handler.java` | `exception` |
| `*Config.java` (security 제외) | `config` |
| `*Util.java`, `*Helper.java` | `util` |
| Flutter `*_screen.dart`, `*_page.dart`, `*_widget.dart` | `ui` |
| Flutter `*_provider.dart`, `*_notifier.dart` | `provider` |
| Flutter `*_service.dart` | `service` |
| Flutter `*_model.dart` | `model` |
| Flutter `*router*.dart`, `*navigation*.dart` | `navigation` |

> 여러 scope에 걸치면 가장 핵심적인 scope 하나를 선택하거나, 범주가 다르면 커밋을 분리하도록 제안한다.

### 커밋 메시지 형식

```
type(scope): subject

body (왜 변경했는지 설명, 선택사항)

Closes #이슈번호
```

**subject 규칙**: 명령형, 소문자 시작, 마침표 없음, 50자 이내 (한글도 가능)

생성 예시:

```
feat(security): JWT 인증 필터 추가

SecurityConfig에 JwtAuthenticationFilter를 등록하고
TokenProvider를 통해 토큰 발급/검증 로직을 분리했다.
기존 세션 기반 인증의 stateless 한계를 해결하기 위함.

Closes #42
```

### 커밋 실행 명령

```bash
git add {변경된 파일들}
git commit -m "$(cat <<'EOF'
type(scope): subject

body

Closes #번호
EOF
)"
```

### 커밋 메시지 검증

사용자가 커밋 메시지를 보여주면 다음을 확인한다:
- `type(scope): subject` 형식 준수 여부
- type이 정의된 목록 내에 있는지
- subject가 50자 이내인지
- 마침표로 끝나지 않는지

위반 항목을 명시하고 수정된 버전을 제시한다.

---

## 3단계: 작업 완료 → PR 생성

사용자가 PR 작성을 요청하면 이 흐름을 따른다.

### PR 생성 절차

1. 현재 브랜치 확인: `git branch --show-current`
2. 변경 커밋 목록 확인: `git log dev..HEAD --oneline` (hotfix면 `main..HEAD`)
3. 브랜치 타입에서 `--base` 결정: hotfix → `main`, 나머지 → `dev`
4. PR 제목과 body를 채워 `gh pr create` 실행

```bash
gh pr create \
  --title "[TYPE/SCOPE] 작업 설명" \
  --body "$(cat <<'EOF'
## 📌 관련 이슈
Closes #이슈번호

## 🎯 변경 사항 요약
(이 PR이 무엇을 구현/수정하는지)

## 🔄 변경 사항 상세

### Backend
- (해당 없으면 생략)

### Frontend
- (해당 없으면 생략)

### 기타
- (해당 없으면 생략)

## ✅ 테스트 완료
- [ ] 단위 테스트 작성 및 통과
- [ ] 통합 테스트 수행
- [ ] 로컬 테스트 완료
- [ ] 성능 테스트 (필요시)

## 📸 스크린샷 (UI 변경 시)
(해당 없으면 생략)

## 📝 체크리스트
- [ ] 코드 리뷰 가이드라인 준수
- [ ] 문서 업데이트 완료
- [ ] Conventional Commits 준수
- [ ] 불필요한 콘솔 로그 제거
- [ ] 보안 취약점 검토

## 🔗 참고 자료
- (없으면 생략)
EOF
)" \
  --base dev
```

---

## 브랜치 전략 요약

| 작업 유형 | 브랜치 형식 | 베이스 | 병합 대상 |
|-----------|-----------|--------|---------|
| 새 기능 | `feature/{N}-name` | dev | dev → main |
| 버그 수정 | `bugfix/{N}-name` | dev | dev → main |
| 긴급 수정 | `hotfix/{N}-name` | main | main → dev |
| 리팩토링 | `refactor/{N}-name` | dev | dev → main |
| 테스트 | `test/{N}-name` | dev | dev |
| 문서 | `docs/{N}-name` | dev | dev |

---

## 컨벤션 상세

전체 컨벤션 (type 목록, scope 전체 목록, 라벨 목록, 예제 모음)은 `references/conventions.md`를 참조하라.

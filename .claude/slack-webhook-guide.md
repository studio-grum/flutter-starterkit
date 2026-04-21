# Slack Webhook 설정 가이드

Claude Code 작업 완료 시 Slack 모바일 알림을 받기 위한 설정 방법입니다.

---

## 1. Slack 앱 생성

1. [https://api.slack.com/apps](https://api.slack.com/apps) 접속
2. **Create New App** 클릭
3. **From scratch** 선택
4. App Name 입력 (예: `Claude Code Bot`) → 알림을 받을 워크스페이스 선택 → **Create App**

> 기존 앱이 있다면 해당 앱을 선택해도 됩니다.

---

## 2. Incoming Webhooks 활성화

1. 좌측 메뉴 **Features → Incoming Webhooks** 클릭
2. **Activate Incoming Webhooks** 토글을 **On**으로 전환
3. 페이지 하단 **Add New Webhook to Workspace** 클릭
4. 알림을 받을 채널 선택 → **Allow**

---

## 3. Webhook URL 복사

활성화 후 생성된 URL을 복사합니다.

```
https://hooks.slack.com/services/T.../B.../...
```

---

## 4. .env 파일에 URL 입력

프로젝트 루트의 `.env` 파일을 열어 아래 항목에 복사한 URL을 붙여넣습니다.

```env
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/T.../B.../...
```

---

## 5. 동작 확인

터미널에서 아래 명령어로 알림이 오는지 확인합니다.

```bash
SLACK_URL=$(grep '^SLACK_WEBHOOK_URL=' .env | cut -d'=' -f2-)
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"✅ Claude Code 테스트 메시지"}' \
  "$SLACK_URL"
```

`ok` 응답이 오고 Slack에 메시지가 도착하면 설정 완료입니다.

---

## 참고

- `.env`에 `SLACK_WEBHOOK_URL`이 비어 있으면 훅이 조용히 skip됩니다 (에러 없음)
- `.env`는 `.gitignore`에 포함되어 있어 URL이 저장소에 노출되지 않습니다

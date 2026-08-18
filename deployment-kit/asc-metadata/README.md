# App Store Connect — 메타데이터 업로드 (AI Expiry Reminder)

문구 파일을 수정한 뒤 스크립트로 App Store Connect에 반영합니다.

- **기본 Bundle ID:** `com.smartcompany.useByDate`
- **한국어 앱명:** AI 유통기한 알리미
- **영문 앱명:** AI Expiry Reminder

## 파일

### `listings.mjs`
로케일별 스토어 문구.

### `store-urls.mjs`
공통 `serverBaseUrl`, `privacyUrl`, `supportUrl`, `marketingUrl`, `copyright`.  
`privacyUrl` → App Store `privacyPolicyUrl` 필드, `supportUrl` / `marketingUrl` 기본값은 `https://smartcompany.github.io` 입니다.

### `whats-new.json`
버전별 새로운 기능.

### `review-notes.mjs`
심사팀용 App Review Notes. `privacyUrl` / `supportUrl` 을 공용 URL 설정에서 자동 반영합니다.

## 1회 설정

```bash
cd client/deployment-kit/asc-metadata
cp .env.example .env
```

`.env`에 최소한 `ASC_ISSUER_ID`를 채우세요.

App Review Notes까지 자동 업로드하려면 review contact도 넣는 것이 좋습니다.

```bash
ASC_REVIEW_CONTACT_FIRST_NAME="Yong Geon"
ASC_REVIEW_CONTACT_LAST_NAME=Kim
ASC_REVIEW_CONTACT_EMAIL=...
ASC_REVIEW_CONTACT_PHONE=+8210...
```

## 사용

`client/` 에서:

```bash
./deployment-kit/scripts/upload_ios_metadata.sh --dry-run
./deployment-kit/scripts/upload_ios_metadata.sh
./deployment-kit/scripts/upload_ios_metadata.sh --only promotionalText
./deployment-kit/scripts/upload_ios_metadata.sh --only reviewNotes
./deployment-kit/scripts/upload_ios_metadata.sh --bundle-id com.smartcompany.useByDate
```

또는 이 폴더에서:

```bash
cd client/deployment-kit/asc-metadata
./update-metadata.sh --dry-run
./update-whats-new.sh
```

## 번들 아이디

기본값은 `com.smartcompany.useByDate` 이지만, 실행 시 덮어쓸 수 있습니다.

```bash
./deployment-kit/scripts/upload_ios_metadata.sh --bundle-id com.example.otherapp
```

`ASC_APP_ID`를 함께 주면 bundle id 조회 없이 바로 해당 앱으로 업로드할 수 있습니다.

# Google Play — AI Expiry Reminder (UseByDate)

Google Play Console API용 메타데이터 업로드 스크립트입니다.  
스토어 문구 원본은 `../asc-metadata/listings.mjs` 를 재사용합니다.  
URL·연락처는 `../app-config.json` 에서 읽습니다.

| App Store (ASC) | Google Play | API 업로드 |
|-----------------|-------------|------------|
| `name` | `title` (≤30자) | ✅ `edits.listings` |
| `subtitle` / `promotionalText` | `shortDescription` (≤80자) | ✅ |
| `description` | `fullDescription` (≤4000자) | ✅ (설명 하단에 privacy URL 문구 포함) |
| `supportUrl` | `contactWebsite` | ✅ `edits.details` |
| `supportEmail` / review contact | `contactEmail`, `contactPhone` | ✅ `edits.details` |
| `privacyPolicyUrl` | App content → Privacy policy | ❌ **Play Console에서 수동** (스크립트가 URL 출력) |

Play 로케일: `ko-KR`, `en-US`, `ja-JP`, `zh-CN`

## 설정

```bash
cd client/deployment-kit/play-metadata
cp .env.example .env
npm install
```

`app-config.json` 의 `serverBaseUrl`, `privacyPath`, `supportUrl`, `supportEmail`, `reviewContactPhone` 을 맞춰 두세요.

## 사용

`client/` 에서:

```bash
./deployment-kit/scripts/upload_android_metadata.sh --dry-run
./deployment-kit/scripts/upload_android_metadata.sh
./deployment-kit/scripts/upload_android_metadata.sh --only details
./deployment-kit/scripts/upload_android_metadata.sh --package-name com.smartcompany.useByDate
```

업로드 후 터미널에 **개인정보처리방침 URL** 이 출력됩니다.  
Play Console → **정책 → 앱 콘텐츠 → 개인정보처리방침** 에 한 번 붙여 넣으세요 (API 미지원).

출시 노트:

```bash
cd client/deployment-kit/play-metadata
./update-whats-new.sh --version-code 12 --track production --dry-run
./update-whats-new.sh --version-code 12 --track production
```

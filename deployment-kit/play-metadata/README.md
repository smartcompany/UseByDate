# Google Play — AI Expiry Reminder (UseByDate)

Google Play Console API용 메타데이터 업로드 스크립트입니다.  
스토어 문구 원본은 `../asc-metadata/listings.mjs` 를 재사용합니다.

| App Store (ASC) | Google Play |
|-----------------|-------------|
| `name` | `title` (≤30자) |
| `subtitle` / `promotionalText` | `shortDescription` (≤80자) |
| `description` | `fullDescription` (≤4000자) |

Play 로케일: `ko-KR`, `en-US`, `ja-JP`, `zh-CN`

## 설정

```bash
cd client/deployment-kit/play-metadata
cp .env.example .env
npm install
```

## 사용

`client/` 에서:

```bash
./deployment-kit/scripts/upload_android_metadata.sh --dry-run
./deployment-kit/scripts/upload_android_metadata.sh
./deployment-kit/scripts/upload_android_metadata.sh --package-name com.smartcompany.useByDate
```

출시 노트:

```bash
cd client/deployment-kit/play-metadata
./update-whats-new.sh --version-code 12 --track production --dry-run
./update-whats-new.sh --version-code 12 --track production
```

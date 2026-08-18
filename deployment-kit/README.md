# Deployment Kit

배포 직전마다 AI에게 여러 번 설명하지 않도록 만든 단일 폴더입니다.  
새 앱에서는 이 폴더를 통째로 복붙한 뒤 `app-config.json`만 맞추면 됩니다.

## 구조

```
deployment-kit/
├── app-config.json          # 현재 앱 설정
├── app-config.example.json  # 새 앱용 템플릿
├── asc-metadata/            # App Store Connect 메타데이터
├── play-metadata/           # Google Play 메타데이터
└── scripts/
    ├── build_android.sh
    ├── build_ios.sh
    ├── upload_ios_metadata.sh
    ├── upload_android_metadata.sh
    ├── release_all.sh
    ├── release_ios_all.sh
    └── release_android_all.sh
```

## 사용법

`client/` 에서:

```bash
# iOS 전체 (메타 + 빌드)
./deployment-kit/scripts/release_ios_all.sh

# Android 전체 (빌드 + 메타)
./deployment-kit/scripts/release_android_all.sh

# 개별 실행
./deployment-kit/scripts/upload_ios_metadata.sh --dry-run
./deployment-kit/scripts/upload_android_metadata.sh --dry-run
./deployment-kit/scripts/build_ios.sh --bump
./deployment-kit/scripts/build_android.sh
```

## 새 앱에 복붙할 때

> 이 프로젝트에 `deployment-kit`를 맞춰줘.  
> `deployment-kit/app-config.json` 기준으로 bundle id, package name, server url, privacy url, metadata, build scripts를 현재 프로젝트에 연결해줘.

## 설정 파일

- `app-config.json`: 앱명, bundle/package id, URL, 키 경로, review contact
- `asc-metadata/listings.mjs`: App Store 문구
- `asc-metadata/store-urls.mjs`: privacy / support / marketing / copyright URL
- `play-metadata/`: Play 업로드 (문구는 `asc-metadata/listings.mjs` 재사용)

자세한 내용은 `asc-metadata/README.md`, `play-metadata/README.md` 참고.

import { privacyUrl } from './store-urls.mjs';

/** App Store listing copy — AI Expiry Reminder (AI 유통기한 알리미). Edit and run ./update-metadata.sh */
export default {
  ko: {
    name: 'AI 유통기한 알리미',
    subtitle: '사진으로 식품 기한 정리',
    promotionalText:
      '식품 포장 사진을 찍거나 고르면 AI가 유통기한을 읽거나 추정해 저장하고, 임박 전에 로컬 알림으로 알려줍니다.',
    description: `
AI 유통기한 알리미는 냉장고와 팬트리 속 식품의 유통기한을 사진으로 기록하고, 임박 순으로 정리해 주는 앱입니다.

■ 주요 기능
• 카메라 또는 앨범에서 식품 사진 추가
• AI로 상품명과 유통기한 분석
• 저장 전 항목 검토 및 수정
• 유통기한 임박순 목록 / 그리드 보기
• 상품 상세에서 날짜 직접 수정
• 로컬 알림으로 당일 또는 며칠 전 미리 알림
• 한국어 · English · 日本語 · 中文 UI

■ 이런 분께 추천합니다
• 냉장고 속 식품 기한을 자주 놓치는 분
• 장을 본 뒤 사진으로 간단히 정리하고 싶은 분
• 집에서 식품 재고를 빠르게 확인하고 싶은 분

■ AI 분석 안내
• 선택한 사진은 유통기한 분석을 위해 서버를 거쳐 Google Gemini API로 전송될 수 있습니다.
• 분석 결과는 수정 후 저장할 수 있습니다.

■ 데이터 보관
• 저장된 항목과 사진 정보는 기본적으로 기기 안에 보관됩니다.

■ 광고
• 사진 추가 횟수에 따라 전면 광고가 표시될 수 있습니다.

개인정보 처리방침: ${privacyUrl}
`,
    keywords:
      '유통기한,냉장고,식품,알림,재고,사진,AI,만료일,식자재,정리,저장,팬트리',
  },
  'en-US': {
    name: 'AI Expiry Reminder',
    subtitle: 'Track food dates by photo',
    promotionalText:
      'Snap food package photos, let AI read or estimate expiry dates, and get local reminders before they are due.',
    description: `
AI Expiry Reminder helps you track food expiry dates from package photos and keep items sorted by urgency.

■ KEY FEATURES
• Add food photos from camera or photo library
• AI reads or estimates product names and expiry dates
• Review and edit detected items before saving
• List and grid views sorted by urgency
• Edit expiry dates manually in item details
• Local reminders on the day or days before expiry
• Korean, English, Japanese, and Chinese UI

■ GREAT FOR
• People who forget what expires soon in the fridge
• Anyone who wants a quick photo-based pantry log
• Households tracking groceries at home

■ AI ANALYSIS
• Selected photos may be sent through our API to Google Gemini for expiry analysis.
• You can review and correct results before saving.

■ DATA
• Saved items and photo references are stored primarily on your device.

■ ADS
• Interstitial ads may appear based on how often you add photos.

Privacy Policy: ${privacyUrl}
`,
    keywords:
      'expiry,food,fridge,pantry,reminder,grocery,inventory,date,photo,AI,kitchen,storage',
  },
  ja: {
    name: 'AI賞味期限リマインダー',
    subtitle: '写真で食品期限を管理',
    promotionalText:
      '食品パッケージを撮影すると、AIが賞味期限を読み取りまたは推定し、期限前にローカル通知で知らせます。',
    description: `
AI賞味期限リマインダーは、食品パッケージの写真から賞味期限を記録し、期限が近い順に整理できるアプリです。

■ 主な機能
• カメラまたはアルバムから食品写真を追加
• AIで商品名と賞味期限を分析
• 保存前に検出結果を確認・修正
• 期限が近い順のリスト / グリッド表示
• 詳細画面で日付を手動編集
• 当日または数日前のローカル通知
• 韓国語・英語・日本語・中国語UI

■ こんな方におすすめ
• 冷蔵庫の食品期限を忘れがちな方
• 写真で簡単に食品管理したい方
• 家庭の食材在庫を整理したい方

■ AI分析について
• 選択した写真は期限分析のため、API経由でGoogle Geminiに送信される場合があります。
• 保存前に結果を確認して修正できます。

■ データ
• 保存した項目と写真情報は主に端末内に保管されます。

■ 広告
• 写真追加の頻度に応じてインタースティシャル広告が表示される場合があります。

プライバシーポリシー: ${privacyUrl}
`,
    keywords: '賞味期限,食品,冷蔵庫,通知,在庫,写真,AI,キッチン,食材,管理,保存',
  },
  'zh-Hans': {
    name: 'AI保质期提醒',
    subtitle: '拍照管理食品期限',
    promotionalText:
      '拍摄食品包装照片，AI 可读取或估算保质期，并在到期前通过本地提醒通知你。',
    description: `
AI保质期提醒可通过食品包装照片记录保质期，并按紧急程度整理你的食品项目。

■ 主要功能
• 从相机或相册添加食品照片
• AI 分析商品名称和保质期
• 保存前可检查并修改识别结果
• 按紧急程度排序的列表 / 网格视图
• 在详情页手动修改日期
• 到期当天或提前几天本地提醒
• 支持韩语、英语、日语、中文界面

■ 适合谁
• 经常忘记冰箱里哪些食品快到期的人
• 希望用照片快速整理食品的人
• 想在家管理食材库存的人

■ AI 分析说明
• 所选照片可能会通过我们的 API 发送到 Google Gemini 进行保质期分析。
• 保存前你可以检查并修正结果。

■ 数据
• 已保存项目和照片信息主要存储在本机。

■ 广告
• 根据添加照片的频率，可能显示插屏广告。

隐私政策: ${privacyUrl}
`,
    keywords: '保质期,食品,冰箱,提醒,库存,拍照,AI,厨房,食材,管理,到期',
  },
};

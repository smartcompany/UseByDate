// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '賞味期限';

  @override
  String errorWithMessage(String message) {
    return 'エラー: $message';
  }

  @override
  String get emptyHomeTitle => 'いつまで使える？';

  @override
  String get emptyHomeBody => 'パッケージを撮ると日付を読むか推定し、その日にお知らせします。';

  @override
  String get emptyHomeStep1 => '1つずつ、またはまとめて撮影';

  @override
  String get emptyHomeStep2 => '名前と期限を確認';

  @override
  String get emptyHomeStep3 => '当日または数日前に通知';

  @override
  String get emptyHomeCtaHint => '下のカメラまたはアルバムから始めましょう';

  @override
  String get camera => 'カメラ';

  @override
  String get album => 'アルバム';

  @override
  String get settingsTooltip => '設定';

  @override
  String get settingsTitle => '設定';

  @override
  String get preparingPhoto => '写真を準備しています…';

  @override
  String get imageCompressFailed => '画像を圧縮できませんでした。';

  @override
  String get analyzingPhoto => '食品と期限を探しています…';

  @override
  String get noItemsDetected => '食品が見つかりませんでした。手動で追加してください。';

  @override
  String itemsFoundCount(int count) {
    return '$count件見つかりました。必要なら編集してください。';
  }

  @override
  String aiDetectFailed(String error) {
    return '認識に失敗しました。手動で追加できます。\n$error';
  }

  @override
  String get addItemsTitle => '項目を確認';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get retake => '撮り直す';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get scanAgain => '再スキャン';

  @override
  String get addPhoto => '写真を追加';

  @override
  String get removePhoto => '写真を削除';

  @override
  String photosCountLabel(int count, int max) {
    return '写真 $count/$max';
  }

  @override
  String maxPhotosReached(int count) {
    return '写真は最大$count枚まで追加できます。';
  }

  @override
  String get addItemManually => '項目を追加';

  @override
  String get itemNameLabel => '名前';

  @override
  String get itemNameHint => '例: 牛乳';

  @override
  String get expiryDateLabel => '期限';

  @override
  String get noExpiryDate => '日付なし';

  @override
  String get pickExpiryDate => '日付を選ぶ';

  @override
  String get clearExpiryDate => '日付を消す';

  @override
  String get sourcePrinted => '印字された日付';

  @override
  String get sourceEstimated => '推定';

  @override
  String get sourceUser => '編集済み';

  @override
  String get reasonLabel => 'この日付の理由';

  @override
  String get addAtLeastOneItem => '名前のある項目を1つ以上追加してください。';

  @override
  String saveFailed(String error) {
    return '保存できませんでした: $error';
  }

  @override
  String get firstSaveHint => '保存しました。期限前にお知らせします。';

  @override
  String get sectionExpired => '期限切れ';

  @override
  String get sectionToday => '今日';

  @override
  String get sectionSoon => 'まもなく';

  @override
  String get sectionLater => '余裕あり';

  @override
  String get sectionNoDate => '日付なし';

  @override
  String daysLeft(int count) {
    return '残り$count日';
  }

  @override
  String expiredDaysAgo(int count) {
    return '$count日前に期限切れ';
  }

  @override
  String get expiresToday => '今日まで';

  @override
  String get expiresTomorrow => '明日まで';

  @override
  String get productDetailTitle => '項目';

  @override
  String get deleteProductTitle => '項目を削除';

  @override
  String get deleteProductMessage => 'この項目と通知を削除しますか？';

  @override
  String get productNotFound => '項目が見つかりません';

  @override
  String get notifyEnabledTitle => '通知';

  @override
  String get notifyEnabledSubtitle => '通知日に知らせる';

  @override
  String get settingsNotifyDaysTitle => '事前通知';

  @override
  String get settingsNotifyDaysOnDay => '当日';

  @override
  String settingsNotifyDaysBefore(int count) {
    return '$count日前';
  }

  @override
  String get settingsNotifyTimeTitle => '通知時刻';

  @override
  String get settingsSaveToAlbumTitle => '撮影した写真をギャラリーに保存';

  @override
  String get settingsSaveToAlbumSubtitle => '端末の写真アプリにも残します';

  @override
  String get settingsNotificationsTitle => '通知';

  @override
  String get settingsNotificationsSubtitle => 'リマインダーのために通知を許可してください';

  @override
  String get notificationPermissionDenied => '通知がオフです。システム設定でオンにしてください。';

  @override
  String get notificationTitle => '今日が期限です';

  @override
  String notificationBodyOnDay(String name) {
    return '$name の期限は今日です。';
  }

  @override
  String notificationBodyBefore(String name, int count) {
    return '$name の期限まであと$count日です。';
  }

  @override
  String get photoAddAdTitle => '広告を見て食品の写真を追加しますか？';

  @override
  String photoAddAdMessage(int count) {
    return '写真の解析に成功したあと $count 回ごとに短い広告が表示されます。広告を見ると、カメラやアルバムから食品を追加できます。';
  }

  @override
  String get photoAddAdContinue => '広告を見て写真を追加';

  @override
  String get photoAddAdTitleScan => '広告を見て再スキャンしますか？';

  @override
  String photoAddAdMessageScan(int count) {
    return '写真解析の成功 $count 回ごとに短い広告が表示されます。広告を見ると、AIで期限を再検出できます。';
  }

  @override
  String get photoAddAdContinueScan => '広告を見て再スキャン';

  @override
  String get photoAddAdCancel => 'キャンセル';

  @override
  String get photoAddAdLoading => '広告を読み込み中…';
}

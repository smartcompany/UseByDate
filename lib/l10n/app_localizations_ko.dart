// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'AI 유통기한 알리미';

  @override
  String errorWithMessage(String message) {
    return '오류: $message';
  }

  @override
  String get emptyHomeTitle => '이거 언제까지예요?';

  @override
  String get emptyHomeBody =>
      '사진을 올리면 AI가 상품명과 유통기한을 읽거나 추정하고, 임박하면 알려드려요. 이렇게 찍으면 돼요.';

  @override
  String get emptyHomeStep1 => '쿠팡 등 구매 목록 화면을 캡처해서 올리기';

  @override
  String get emptyHomeStep2 => '여러 상품을 한 번에 그룹으로 찍기';

  @override
  String get emptyHomeStep3 => '포장에서 유통기한이 적힌 부분을 찍기';

  @override
  String get emptyHomeCtaHint =>
      '결과를 확인·저장하면 당일 또는 며칠 전에 알려드려요. 아래 카메라나 앨범으로 시작하세요';

  @override
  String get camera => '카메라';

  @override
  String get album => '앨범';

  @override
  String get settingsTooltip => '설정';

  @override
  String get settingsTitle => '설정';

  @override
  String get layoutGridTooltip => '격자 보기';

  @override
  String get layoutListTooltip => '목록 보기';

  @override
  String get preparingPhoto => '사진을 준비하고 있어요…';

  @override
  String get imageCompressFailed => '이미지를 압축하지 못했어요.';

  @override
  String get cameraPermissionDenied => '카메라 권한이 꺼져 있어요. 설정에서 켜 주세요.';

  @override
  String get photoPermissionDenied => '사진 접근 권한이 꺼져 있어요. 설정에서 켜 주세요.';

  @override
  String get openSettings => '설정';

  @override
  String get analyzingPhoto => '식품과 유통기한을 찾고 있어요…';

  @override
  String get noItemsDetected => '식품을 찾지 못했어요. 직접 추가해 주세요.';

  @override
  String itemsFoundCount(int count) {
    return '$count개를 찾았어요. 필요하면 수정하세요.';
  }

  @override
  String aiDetectFailed(String error) {
    return '인식에 실패했어요. 직접 추가할 수 있어요.\n$error';
  }

  @override
  String get addItemsTitle => '항목 확인';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get retake => '다시 촬영';

  @override
  String get gallery => '갤러리';

  @override
  String get scanAgain => '다시 스캔';

  @override
  String get addPhoto => '사진 추가';

  @override
  String get removePhoto => '사진 삭제';

  @override
  String photosCountLabel(int count, int max) {
    return '사진 $count/$max';
  }

  @override
  String maxPhotosReached(int count) {
    return '사진은 최대 $count장까지 추가할 수 있어요.';
  }

  @override
  String get addItemManually => '항목 추가';

  @override
  String get itemNameLabel => '이름';

  @override
  String get itemNameHint => '예: 우유';

  @override
  String get expiryDateLabel => '유통기한';

  @override
  String get noExpiryDate => '날짜 없음';

  @override
  String get pickExpiryDate => '날짜 선택';

  @override
  String get clearExpiryDate => '날짜 지우기';

  @override
  String get sourcePrinted => '인쇄된 날짜';

  @override
  String get sourceEstimated => '추정';

  @override
  String get sourceUser => '수정됨';

  @override
  String get reasonLabel => '이 날짜인 이유';

  @override
  String get addAtLeastOneItem => '이름이 있는 항목을 하나 이상 추가하세요.';

  @override
  String saveFailed(String error) {
    return '저장하지 못했어요: $error';
  }

  @override
  String get firstSaveHint => '저장했어요. 기한 전에 알려드릴게요.';

  @override
  String get sectionExpired => '만료';

  @override
  String get sectionToday => '오늘';

  @override
  String get sectionSoon => '임박';

  @override
  String get sectionLater => '여유';

  @override
  String get sectionNoDate => '날짜 없음';

  @override
  String daysLeft(int count) {
    return '$count일 남음';
  }

  @override
  String expiredDaysAgo(int count) {
    return '$count일 지남';
  }

  @override
  String get expiresToday => '오늘까지';

  @override
  String get expiresTomorrow => '내일까지';

  @override
  String get productDetailTitle => '항목';

  @override
  String get deleteProductTitle => '항목 삭제';

  @override
  String get deleteProductMessage => '이 항목과 알림을 삭제할까요?';

  @override
  String get productNotFound => '항목을 찾을 수 없어요';

  @override
  String get notifyEnabledTitle => '알림';

  @override
  String get notifyEnabledSubtitle => '알림일에 알려주기';

  @override
  String get settingsNotifyDaysTitle => '미리 알림';

  @override
  String get settingsNotifyDaysOnDay => '당일';

  @override
  String settingsNotifyDaysBefore(int count) {
    return '$count일 전';
  }

  @override
  String get settingsNotifyTimeTitle => '알림 시각';

  @override
  String get settingsSaveToAlbumTitle => '촬영 사진을 갤러리에 저장';

  @override
  String get settingsSaveToAlbumSubtitle => '기기 사진 앱에도 함께 보관합니다';

  @override
  String get settingsNotificationsTitle => '알림';

  @override
  String get settingsNotificationsSubtitle => '제때 알려 주려면 알림을 허용하세요';

  @override
  String get notificationPermissionDenied => '알림이 꺼져 있어요. 시스템 설정에서 켜 주세요.';

  @override
  String get notificationTitle => '오늘까지예요';

  @override
  String notificationBodyOnDay(String name) {
    return '$name 오늘이 유통기한입니다.';
  }

  @override
  String notificationBodyBefore(String name, int count) {
    return '$name 유통기한이 $count일 남았습니다.';
  }

  @override
  String get photoAddAdTitle => '광고를 보고 식품 사진을 추가할까요?';

  @override
  String photoAddAdMessage(int count) {
    return '사진 분석에 성공한 뒤 $count회마다 짧은 광고가 나옵니다. 광고를 보면 카메라나 앨범으로 식품을 더 추가할 수 있습니다.';
  }

  @override
  String get photoAddAdContinue => '광고 보고 사진 추가';

  @override
  String get photoAddAdTitleScan => '광고를 보고 다시 스캔할까요?';

  @override
  String photoAddAdMessageScan(int count) {
    return '사진 분석 성공 $count회마다 짧은 광고가 나옵니다. 광고를 보면 AI로 유통기한을 다시 찾을 수 있습니다.';
  }

  @override
  String get photoAddAdContinueScan => '광고 보고 다시 스캔';

  @override
  String get photoAddAdCancel => '취소';

  @override
  String get photoAddAdLoading => '광고를 불러오는 중…';

  @override
  String get selectItemsTooltip => '항목 선택';

  @override
  String selectedCount(int count) {
    return '$count개 선택';
  }

  @override
  String get selectAll => '전체 선택';

  @override
  String get deselectAll => '선택 해제';

  @override
  String get deleteSelectedTitle => '선택 항목 삭제';

  @override
  String deleteSelectedMessage(int count) {
    return '선택한 $count개 항목과 알림을 삭제할까요?';
  }

  @override
  String get deleteSelected => '선택 삭제';

  @override
  String get shareAppTitle => '앱 공유';

  @override
  String get shareAppSubtitle => '친구에게 다운로드 링크 보내기';

  @override
  String get shareAppMessage => 'AI 유통기한 알리미 — 사진으로 식품 유통기한을 관리해요';

  @override
  String shareAppFailed(String error) {
    return '공유 실패: $error';
  }
}

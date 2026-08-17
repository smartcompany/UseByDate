// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'AI保质期提醒';

  @override
  String errorWithMessage(String message) {
    return '错误：$message';
  }

  @override
  String get emptyHomeTitle => '这个什么时候过期？';

  @override
  String get emptyHomeBody => '拍下包装，我们会读取或估算日期，并在到期时提醒你。';

  @override
  String get emptyHomeStep1 => '拍一件或一次拍多件';

  @override
  String get emptyHomeStep2 => '核对名称和保质期';

  @override
  String get emptyHomeStep3 => '当天或提前几天收到提醒';

  @override
  String get emptyHomeCtaHint => '从下方相机或相册开始';

  @override
  String get camera => '相机';

  @override
  String get album => '相册';

  @override
  String get settingsTooltip => '设置';

  @override
  String get settingsTitle => '设置';

  @override
  String get layoutGridTooltip => '网格视图';

  @override
  String get layoutListTooltip => '列表视图';

  @override
  String get preparingPhoto => '正在准备照片…';

  @override
  String get imageCompressFailed => '无法压缩图片。';

  @override
  String get cameraPermissionDenied => '相机权限已关闭。请在设置中开启后再拍摄。';

  @override
  String get photoPermissionDenied => '照片访问权限已关闭。请在设置中开启后再选择。';

  @override
  String get openSettings => '设置';

  @override
  String get analyzingPhoto => '正在识别食品和保质期…';

  @override
  String get noItemsDetected => '未检测到食品。请手动添加。';

  @override
  String itemsFoundCount(int count) {
    return '找到 $count 项。可按需修改。';
  }

  @override
  String aiDetectFailed(String error) {
    return '识别失败。你可以手动添加。\n$error';
  }

  @override
  String get addItemsTitle => '核对项目';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get retake => '重拍';

  @override
  String get gallery => '图库';

  @override
  String get scanAgain => '重新扫描';

  @override
  String get addPhoto => '添加照片';

  @override
  String get removePhoto => '删除照片';

  @override
  String photosCountLabel(int count, int max) {
    return '照片 $count/$max';
  }

  @override
  String maxPhotosReached(int count) {
    return '最多可添加 $count 张照片。';
  }

  @override
  String get addItemManually => '添加项目';

  @override
  String get itemNameLabel => '名称';

  @override
  String get itemNameHint => '例如：牛奶';

  @override
  String get expiryDateLabel => '保质期';

  @override
  String get noExpiryDate => '暂无日期';

  @override
  String get pickExpiryDate => '选择日期';

  @override
  String get clearExpiryDate => '清除日期';

  @override
  String get sourcePrinted => '包装日期';

  @override
  String get sourceEstimated => '估算';

  @override
  String get sourceUser => '已修改';

  @override
  String get reasonLabel => '该日期的原因';

  @override
  String get addAtLeastOneItem => '请至少添加一项并填写名称。';

  @override
  String saveFailed(String error) {
    return '无法保存：$error';
  }

  @override
  String get firstSaveHint => '已保存。到期前会提醒你。';

  @override
  String get sectionExpired => '已过期';

  @override
  String get sectionToday => '今天';

  @override
  String get sectionSoon => '即将到期';

  @override
  String get sectionLater => '较晚';

  @override
  String get sectionNoDate => '无日期';

  @override
  String daysLeft(int count) {
    return '还剩 $count 天';
  }

  @override
  String expiredDaysAgo(int count) {
    return '已过期 $count 天';
  }

  @override
  String get expiresToday => '今天到期';

  @override
  String get expiresTomorrow => '明天到期';

  @override
  String get productDetailTitle => '项目';

  @override
  String get deleteProductTitle => '删除项目';

  @override
  String get deleteProductMessage => '删除此项目及其提醒？';

  @override
  String get productNotFound => '未找到项目';

  @override
  String get notifyEnabledTitle => '提醒';

  @override
  String get notifyEnabledSubtitle => '在提醒日通知';

  @override
  String get settingsNotifyDaysTitle => '提前提醒';

  @override
  String get settingsNotifyDaysOnDay => '到期当天';

  @override
  String settingsNotifyDaysBefore(int count) {
    return '提前 $count 天';
  }

  @override
  String get settingsNotifyTimeTitle => '提醒时间';

  @override
  String get settingsSaveToAlbumTitle => '将拍摄的照片保存到图库';

  @override
  String get settingsSaveToAlbumSubtitle => '同时保存在设备的照片应用中';

  @override
  String get settingsNotificationsTitle => '通知';

  @override
  String get settingsNotificationsSubtitle => '请允许通知以便按时提醒';

  @override
  String get notificationPermissionDenied => '通知已关闭。请在系统设置中开启。';

  @override
  String get notificationTitle => '今天到期';

  @override
  String notificationBodyOnDay(String name) {
    return '$name 今天到期。';
  }

  @override
  String notificationBodyBefore(String name, int count) {
    return '$name 还有 $count 天到期。';
  }

  @override
  String get photoAddAdTitle => '观看广告以添加食品照片？';

  @override
  String photoAddAdMessage(int count) {
    return '每成功分析 $count 次照片会显示一次短广告。观看后即可用相机或相册添加更多食品。';
  }

  @override
  String get photoAddAdContinue => '观看广告并添加照片';

  @override
  String get photoAddAdTitleScan => '观看广告以重新扫描？';

  @override
  String photoAddAdMessageScan(int count) {
    return '每成功分析 $count 次会显示一次短广告。观看后可用 AI 再次识别保质期。';
  }

  @override
  String get photoAddAdContinueScan => '观看广告并重新扫描';

  @override
  String get photoAddAdCancel => '取消';

  @override
  String get photoAddAdLoading => '正在加载广告…';
}

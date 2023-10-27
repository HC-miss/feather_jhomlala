import 'package:feather_jhomlala/data/model/internal/unit.dart';
import 'package:feather_jhomlala/data/providers/app_local_provider.dart';
import 'package:feather_jhomlala/data/repositories/app_local_repository.dart';
import 'package:get/get.dart';

class SettingService extends GetxService {
  /// 静态变量
  static SettingService get to => Get.find();
  final appLocalRepository = AppLocalRepository(AppLocalProvider());

  // 单位
  Rx<Unit> unit = Unit.metric.obs;

  // 刷新时间
  var refreshTime = 0.obs;

  @override
  void onReady() {
    super.onReady();
    loadSettings();
  }

  void loadSettings() {
    final savedUnit = appLocalRepository.getSavedUnit();
    unit.value = savedUnit;

    final savedRefreshTime = appLocalRepository.getSavedRefreshTime();
    refreshTime.value = savedRefreshTime;
  }

  bool get isMetricUnits {
    return unit.value == Unit.metric;
  }
}

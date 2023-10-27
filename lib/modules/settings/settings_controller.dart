import 'package:feather_jhomlala/data/model/internal/overflow_menu_element.dart';
import 'package:feather_jhomlala/data/model/internal/unit.dart';
import 'package:feather_jhomlala/data/repositories/app_local_repository.dart';
import 'package:feather_jhomlala/data/services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'settings_state.dart';

class SettingsController extends GetxController with StateMixin<SettingsState> {
  final AppLocalRepository appLocalRepository;

  SettingsController({required this.appLocalRepository});

  @override
  void onReady() {
    initSettingState();
    super.onReady();
  }

  void initSettingState() {
    final unit = appLocalRepository.getSavedUnit();
    final savedRefreshTime = appLocalRepository.getSavedRefreshTime();
    final lastRefreshedTime = appLocalRepository.getLastRefreshTime();

    change(
      SettingsState(
        unit: unit,
        refreshTime: savedRefreshTime,
        lastRefreshTime: lastRefreshedTime,
      ),
      status: RxStatus.success(),
    );
  }

  void onChangedUnitState(bool state) {
    Unit unit;
    if (state) {
      unit = Unit.imperial;
    } else {
      unit = Unit.metric;
    }
    appLocalRepository.saveUnit(unit);

    // 更新全局设置
    SettingService.to.unit.value = unit;

    if (status.isSuccess) {
      // 会刷新页面
      value = value?.copyWith(unit: unit);
    }
  }

  void onMenuClicked(PopupMenuElement element) {
    int selectedRefreshTime = 600000;
    if (element.key == const Key("menu_settings_refresh_time_10_minutes")) {
      selectedRefreshTime = 600000;
    } else if (element.key ==
        const Key("menu_settings_refresh_time_15_minutes")) {
      selectedRefreshTime = 900000;
    } else if (element.key ==
        const Key("menu_settings_refresh_time_30_minutes")) {
      selectedRefreshTime = 1800000;
    } else {
      selectedRefreshTime = 3600000;
    }

    appLocalRepository.saveRefreshTime(selectedRefreshTime);

    // 更新全局设置
    SettingService.to.refreshTime.value = selectedRefreshTime;

    if (status.isSuccess) {
      // 会刷新页面
      value = value?.copyWith(refreshTime: selectedRefreshTime);
    }
  }
}

import 'package:feather_jhomlala/core/utils/app_logger.dart';
import 'package:feather_jhomlala/data/model/internal/overflow_menu_element.dart';
import 'package:feather_jhomlala/data/model/internal/unit.dart';
import 'package:feather_jhomlala/widgets/animated_gradient.dart';
import 'package:feather_jhomlala/widgets/loading_widget.dart';
import 'package:feather_jhomlala/widgets/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'settings_controller.dart';
import 'settings_state.dart';

class SettingsPage extends GetView<SettingsController> {
  final List<Color> startGradientColors;

  const SettingsPage({Key? key, this.startGradientColors = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedGradientWidget(
            duration: const Duration(seconds: 3),
            startGradientColors: startGradientColors,
          ),
          SafeArea(
            child: Stack(
              children: [
                controller.obx(
                  (SettingsState? state) {
                    return Container(
                      key: const Key("settings_screen_container"),
                      child: _getSettingsContainer(context, state!),
                    );
                  },
                  onLoading: const LoadingWidget(),
                ),
                const TransparentAppBar(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUnitsChangeWidget(
    AppLocalizations applicationLocalization,
    bool unitImperial,
  ) {
    return Row(
      key: const Key("settings_screen_units_picker"),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${applicationLocalization.units}:",
          style: Theme.of(Get.context!).textTheme.titleSmall,
        ),
        Row(
          children: [
            Text(applicationLocalization.metric),
            Switch(
              value: unitImperial,
              activeColor: Colors.grey,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white,
              inactiveThumbColor: Colors.grey,
              onChanged: controller.onChangedUnitState,
            ),
            Text(applicationLocalization.imperial),
            const SizedBox(height: 10),
          ],
        )
      ],
    );
  }

  Widget _buildRefreshTimePickerWidget(
    AppLocalizations applicationLocalization,
    int refreshTime,
  ) {
    return Row(
      key: const Key("settings_screen_refresh_timer"),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${applicationLocalization.refresh_time}:",
          style: Theme.of(Get.context!).textTheme.titleSmall,
        ),
        Row(
          children: [
            Theme(
              data: Theme.of(Get.context!).copyWith(
                cardColor: Colors.white,
              ),
              child: PopupMenuButton<PopupMenuElement>(
                onSelected: (PopupMenuElement element) {
                  controller.onMenuClicked(element);
                },
                itemBuilder: (BuildContext context) {
                  return _getRefreshTimeMenu(context).map(
                    (PopupMenuElement element) {
                      return PopupMenuItem(
                        value: element,
                        child: Text(
                          element.title!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ).toList();
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    _getSelectedMenuElementText(refreshTime),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  String _getSelectedMenuElementText(int refreshTime) {
    final applicationLocalization = AppLocalizations.of(Get.context!)!;
    switch (refreshTime) {
      case 600000:
        return "10 ${applicationLocalization.minutes}";
      case 900000:
        return "15${applicationLocalization.minutes}";
      case 1800000:
        return "30 ${applicationLocalization.minutes}";
      case 3600000:
        return "60 ${applicationLocalization.minutes}";
      default:
        return "10 ${applicationLocalization.minutes}";
    }
  }

  List<PopupMenuElement> _getRefreshTimeMenu(BuildContext context) {
    final applicationLocalization = AppLocalizations.of(context)!;
    final List<PopupMenuElement> menuList = [];
    menuList.add(PopupMenuElement(
      key: const Key("menu_settings_refresh_time_10_minutes"),
      title: "10 ${applicationLocalization.minutes}",
    ));
    menuList.add(PopupMenuElement(
      key: const Key("menu_settings_refresh_time_15_minutes"),
      title: "15 ${applicationLocalization.minutes}",
    ));
    menuList.add(PopupMenuElement(
      key: const Key("menu_settings_refresh_time_30_minutes"),
      title: "30 ${applicationLocalization.minutes}",
    ));
    menuList.add(PopupMenuElement(
      key: const Key("menu_settings_refresh_time_60_minutes"),
      title: "60 ${applicationLocalization.minutes}",
    ));

    return menuList;
  }

  Widget _getSettingsContainer(BuildContext context, SettingsState state) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      state.lastRefreshTime,
    );
    final applicationLocalization = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          // 构建单位选择组件
          _buildUnitsChangeWidget(
            applicationLocalization,
            state.unit == Unit.imperial,
          ),
          // 描述
          Text(
            applicationLocalization.units_description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 30),
          // 构建刷新时间组件
          _buildRefreshTimePickerWidget(
            applicationLocalization,
            state.refreshTime,
          ),
          const SizedBox(height: 10),
          // 描述
          Text(
            applicationLocalization.refresh_time_description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "${applicationLocalization.last_refresh_time}:",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ]),
          const SizedBox(height: 10),
          Text(
            "$dateTime (${timeago.format(dateTime, locale: Localizations.localeOf(context).languageCode)})",
            key: const Key("settings_screen_last_refresh_time"),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

import 'package:feather_jhomlala/core/utils/app_logger.dart';
import 'package:feather_jhomlala/data/model/internal/overflow_menu_element.dart';
import 'package:feather_jhomlala/data/model/internal/weather_forecast_holder.dart';
import 'package:feather_jhomlala/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forecast_state.dart';

class ForecastController extends GetxController {
  late final WeatherForecastHolder holder;

  final ForecastState state = ForecastState();

  @override
  void onInit() {
    // 在build之前执行
    holder = Get.arguments as WeatherForecastHolder;
    super.onInit();
  }

  void onMenuElementClicked(PopupMenuElement value) {
    List<Color> startGradientColors = [];

    // final LinearGradient gradient = WidgetHelper.getGradient(
    //     sunriseTime: widget._holder.system!.sunrise,
    //     sunsetTime: widget._holder.system!.sunset);
    // startGradientColors = gradient.colors;

    if (value.key == const Key("menu_overflow_settings")) {
      Get.toNamed(AppRoutes.settingsPage, arguments: startGradientColors);
    }
    if (value.key == const Key("menu_overflow_about")) {
      Get.toNamed(AppRoutes.aboutPage, arguments: startGradientColors);
    }
  }
}

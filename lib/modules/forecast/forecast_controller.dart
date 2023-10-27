import 'package:feather_jhomlala/data/model/internal/overflow_menu_element.dart';
import 'package:feather_jhomlala/routes/app_pages.dart';
import 'package:feather_jhomlala/widgets/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forecast_state.dart';

class ForecastController extends GetxController {
  final ForecastState state = ForecastState();

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

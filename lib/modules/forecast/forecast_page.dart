import 'package:feather_jhomlala/core/utils/app_logger.dart';
import 'package:feather_jhomlala/data/services/setting_service.dart';
import 'package:feather_jhomlala/widgets/transparent_app_bar.dart';
import 'package:feather_jhomlala/widgets/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forecast_controller.dart';
import 'widgets/weather_forecast_widget.dart';

class ForecastPage extends GetView<ForecastController> {
  const ForecastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LinearGradient gradient = WidgetHelper.getGradient(
      sunriseTime: controller.holder.system!.sunrise,
      sunsetTime: controller.holder.system!.sunset,
    );

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return Container(
              key: const Key("weather_main_screen_container"),
              decoration: BoxDecoration(gradient: gradient),
              child: WeatherForecastWidget(
                holder: controller.holder,
                width: 300,
                height: 150,
                isMetricUnits: SettingService.to.isMetricUnits,
              ),
            );
          }),
          TransparentAppBar(
            withPopupMenu: true,
            onPopupMenuClicked: controller.onMenuElementClicked,
          )
        ],
      ),
    );
  }
}

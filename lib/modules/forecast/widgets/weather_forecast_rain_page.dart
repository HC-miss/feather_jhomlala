import 'package:feather_jhomlala/core/utils/weather_helper.dart';
import 'package:feather_jhomlala/core/values/app_assets.dart';
import 'package:feather_jhomlala/data/model/internal/chart_data.dart';
import 'package:feather_jhomlala/data/model/internal/weather_forecast_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'weather_forecast_base_page.dart';

class WeatherForecastRainPage extends WeatherForecastBasePage {
  const WeatherForecastRainPage(WeatherForecastHolder? holder, double? width,
      double? height, bool isMetricUnits,
      {Key? key})
      : super(
          holder: holder,
          width: width,
          height: height,
          isMetricUnits: isMetricUnits,
          key: key,
        );

  @override
  Widget getBottomRowWidget(BuildContext context) {
    return Row(
      key: const Key("weather_forecast_rain_page_bottom_row"),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  ChartData getChartData() {
    return super.holder!.setupChartData(
          ChartDataType.rain,
          width!,
          height!,
          isMetricUnits,
        );
  }

  @override
  String getIcon() {
    return AppAssetsImages.iconRainPng;
  }

  @override
  RichText getPageSubtitleWidget(BuildContext context) {
    return RichText(
      key: const Key("weather_forecast_rain_page_subtitle"),
      textDirection: TextDirection.ltr,
      text: TextSpan(
        children: [
          TextSpan(text: 'min ', style: Theme.of(context).textTheme.bodyLarge),
          TextSpan(
            text: WeatherHelper.formatRain(holder!.minRain!),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          TextSpan(
              text: '   max ', style: Theme.of(context).textTheme.bodyLarge),
          TextSpan(
            text: WeatherHelper.formatRain(holder!.maxRain!),
            style: Theme.of(context).textTheme.titleSmall,
          )
        ],
      ),
    );
  }

  @override
  String? getTitleText(BuildContext context) {
    return AppLocalizations.of(context)!.rain;
  }
}

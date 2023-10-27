import 'package:feather_jhomlala/core/utils/weather_helper.dart';
import 'package:feather_jhomlala/core/values/app_assets.dart';
import 'package:feather_jhomlala/data/model/internal/chart_data.dart';
import 'package:feather_jhomlala/data/model/internal/point.dart';
import 'package:feather_jhomlala/data/model/internal/weather_forecast_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'weather_forecast_base_page.dart';

class WeatherForecastTemperaturePage extends WeatherForecastBasePage {
  const WeatherForecastTemperaturePage(WeatherForecastHolder? holder,
      double? width, double? height, bool isMetricUnits,
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
    final List<Point> points = getChartData().points!;
    final List<Widget> widgets = [];

    if (points.length > 2) {
      final double padding = points[1].x - points[0].x - 30;

      // ? 这个高干什么的
      // widgets.add(const SizedBox(
      //   height: 4,
      // ));

      for (int index = 0; index < points.length; index++) {
        widgets.add(Image.asset(
          WeatherHelper.getWeatherIcon(
            holder!.forecastList![index].overallWeatherData![0].id!,
          ),
          width: 30,
          height: 30,
        ));
        widgets.add(
          SizedBox(width: padding),
        );
      }
      // 删除最后一个padding
      widgets.removeLast();
    }

    return Row(
      key: const Key("weather_forecast_temperature_page_bottom_row"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }

  @override
  ChartData getChartData() {
    return super.holder!.setupChartData(
          ChartDataType.temperature,
          width!,
          height!,
          isMetricUnits,
        );
  }

  @override
  String getIcon() {
    return AppAssetsImages.iconThermometerPng;
  }

  @override
  RichText getPageSubtitleWidget(BuildContext context) {
    var minTemperature = holder!.minTemperature;
    var maxTemperature = holder!.maxTemperature;

    if (!isMetricUnits) {
      minTemperature =
          WeatherHelper.convertCelsiusToFahrenheit(minTemperature!);
      maxTemperature =
          WeatherHelper.convertCelsiusToFahrenheit(maxTemperature!);
    }

    final minTemperatureFormatted = WeatherHelper.formatTemperature(
        temperature: minTemperature,
        positions: 1,
        round: false,
        metricUnits: isMetricUnits);
    final maxTemperatureFormatted = WeatherHelper.formatTemperature(
        temperature: maxTemperature,
        positions: 1,
        round: false,
        metricUnits: isMetricUnits);

    return RichText(
      key: const Key("weather_forecast_temperature_page_subtitle"),
      textDirection: TextDirection.ltr,
      text: TextSpan(
        children: [
          TextSpan(text: 'min ', style: Theme.of(context).textTheme.bodyLarge),
          TextSpan(
            text: minTemperatureFormatted,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          TextSpan(
              text: '   max ', style: Theme.of(context).textTheme.bodyLarge),
          TextSpan(
            text: maxTemperatureFormatted,
            style: Theme.of(context).textTheme.titleSmall,
          )
        ],
      ),
    );
  }

  @override
  String? getTitleText(BuildContext context) {
    return AppLocalizations.of(context)!.temperature;
  }
}

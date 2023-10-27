import 'package:feather_jhomlala/core/values/app_colors.dart';
import 'package:flutter/material.dart';

class WidgetHelper {
  static LinearGradient buildGradient(Color startColor, Color endColor) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.2, 0.99],
      colors: [startColor, endColor],
    );
  }

  static LinearGradient buildGradientBasedOnDayCycle(int sunrise, int sunset) {
    final DateTime now = DateTime.now();
    final int nowMs = now.millisecondsSinceEpoch;
    final int sunriseMs = sunrise * 1000;
    final int sunsetMs = sunset * 1000;

    // 未日出（夜晚）
    if (nowMs < sunriseMs) {
      final int lastMidnight =
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      return getNightGradient((sunriseMs - nowMs) / (sunriseMs - lastMidnight));
    } else if (nowMs > sunsetMs) {
      // 已日落（夜晚）
      final int nextMidnight =
          DateTime(now.year, now.month, now.day + 1).millisecondsSinceEpoch;
      return getNightGradient((nowMs - sunsetMs) / (nextMidnight - sunsetMs));
    } else {
      // 白天
      return getDayGradient((nowMs - sunriseMs) / (sunsetMs - sunriseMs));
    }
  }

  /// See also:
  ///
  ///  * [percentage], 当天已过时间的比例.
  static LinearGradient getDayGradient(double percentage) {
    if (percentage <= 0.1 || percentage >= 0.9) {
      return buildGradient(
        AppColors.dawnDuskStartColor,
        AppColors.dawnDuskEndColor,
      );
    } else if (percentage <= 0.2 || percentage >= 0.8) {
      return buildGradient(
        AppColors.morningEveStartColor,
        AppColors.morningEveEndColor,
      );
    } else if (percentage <= 0.4 || percentage >= 0.6) {
      return buildGradient(AppColors.dayStartColor, AppColors.dayEndColor);
    } else {
      return buildGradient(
          AppColors.middayStartColor, AppColors.middayEndColor);
    }
  }

  static LinearGradient getNightGradient(double percentage) {
    if (percentage <= 0.1) {
      return buildGradient(
        AppColors.dawnDuskStartColor,
        AppColors.dawnDuskEndColor,
      );
    } else if (percentage <= 0.2) {
      return buildGradient(
        AppColors.twilightStartColor,
        AppColors.twilightEndColor,
      );
    } else if (percentage <= 0.6) {
      return buildGradient(
        AppColors.nightStartColor,
        AppColors.nightEndColor,
      );
    } else {
      return buildGradient(
        AppColors.midnightStartColor,
        AppColors.midnightEndColor,
      );
    }
  }

  static LinearGradient getGradient({
    int? sunriseTime = 0,
    int? sunsetTime = 0,
  }) {
    if (sunriseTime == 0 && sunsetTime == 0) {
      return buildGradient(
        AppColors.midnightStartColor,
        AppColors.midnightEndColor,
      );
    } else {
      return buildGradientBasedOnDayCycle(sunriseTime!, sunsetTime!);
    }
  }
}

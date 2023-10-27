import 'package:app_settings/app_settings.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:feather_jhomlala/core/utils/app_logger.dart';
import 'package:feather_jhomlala/core/utils/date_time_helper.dart';
import 'package:feather_jhomlala/core/values/app_colors.dart';
import 'package:feather_jhomlala/core/values/constant.dart';
import 'package:feather_jhomlala/data/model/internal/application_error.dart';
import 'package:feather_jhomlala/data/model/internal/overflow_menu_element.dart';
import 'package:feather_jhomlala/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather_jhomlala/data/model/remote/weather_response.dart';
import 'package:feather_jhomlala/modules/main/main_state.dart';
import 'package:feather_jhomlala/widgets/animated_gradient.dart';
import 'package:feather_jhomlala/widgets/loading_widget.dart';
import 'package:feather_jhomlala/widgets/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import 'main_controller.dart';
import '../../widgets/current_weather_widget.dart';
import 'widgets/weather_main_sun_path_widget.dart';

class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        key: const Key("main_screen_overflow_menu"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _buildOverflowMenuAppbar(context),
        ],
      ),
      body: controller.obx(
        (state) {
          return Stack(
            children: [
              _buildGradientWidget(),
              if (state is LocationServiceDisabledMainScreenState)
                _buildLocationServiceDisabledWidget()
              else if (state is PermissionNotGrantedMainScreenState)
                _buildPermissionNotGrantedWidget(
                  state.permanentlyDeniedPermission,
                )
              else if (state is SuccessLoadMainScreenState)
                _buildWeatherWidget(
                  state.weatherResponse,
                  state.weatherForecastListResponse,
                )
              else if (state is FailedLoadMainScreenState)
                _buildFailedToLoadDataWidget(
                  state.applicationError,
                )
              else
                const SizedBox()
            ],
          );
        },
        onLoading: const Stack(
          key: Key('main_screen_loading_widget'),
          children: [
            AnimatedGradientWidget(),
            LoadingWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherWidget(
    WeatherResponse weatherResponse,
    WeatherForecastListResponse weatherForecastListResponse,
  ) {
    BuildContext context = Get.context!;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        key: const Key("main_screen_weather_widget_container"),
        decoration: BoxDecoration(
          gradient: WidgetHelper.getGradient(
            sunriseTime: weatherResponse.system!.sunrise,
            sunsetTime: weatherResponse.system!.sunset,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                weatherResponse.name!,
                key: const Key("main_screen_weather_widget_city_name"),
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                DateTimeHelper.formatDateTime(DateTime.now()),
                key: const Key("main_screen_weather_widget_date"),
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(
                height: 450,
                child: _buildSwiperWidget(
                  weatherResponse,
                  weatherForecastListResponse,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPage(String key, WeatherResponse response,
      WeatherForecastListResponse weatherForecastListResponse) {
    if (controller.pageMap.containsKey(key)) {
      return controller.pageMap[key] ?? const SizedBox();
    } else {
      Widget page;
      if (key == Constant.mainWeatherPage) {
        page = CurrentWeatherWidget(
          weatherResponse: response,
          forecastListResponse: weatherForecastListResponse,
        );
      } else if (key == Constant.weatherMainSunPathPage) {
        page = WeatherMainSunPathWidget(
          system: response.system,
        );
      } else {
        Log.e("Unsupported key: $key");
        page = const SizedBox();
      }
      controller.pageMap[key] = page;
      return page;
    }
  }

  Widget _buildSwiperWidget(
    WeatherResponse weatherResponse,
    WeatherForecastListResponse forecastListResponse,
  ) {
    return Swiper(
      physics: BouncingScrollPhysics(),
      // 动态显示页面 会使每一个页面重建 利用缓存来优化对应页面实例化
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _getPage(
            Constant.mainWeatherPage,
            weatherResponse,
            forecastListResponse,
          );
        } else {
          return _getPage(
            Constant.weatherMainSunPathPage,
            weatherResponse,
            forecastListResponse,
          );
        }
      },
      loop: false,
      itemCount: 2,
      pagination: SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          color: AppColors.swiperInactiveDotColor,
          activeColor: AppColors.swiperActiveDotColor,
        ),
      ),
    );
  }

  Widget _buildPermissionNotGrantedWidget(bool permanentlyDeniedPermission) {
    final AppLocalizations appLocalizations =
        AppLocalizations.of(Get.context!)!;
    final String text = permanentlyDeniedPermission
        ? appLocalizations.error_permissions_not_granted_permanently
        : appLocalizations.error_permissions_not_granted;
    return Column(
      key: const Key("main_screen_permissions_not_granted_widget"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildErrorWidget(text, () {
          controller.locationInit();
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextButton(
            onPressed: () {
              AppSettings.openAppSettings();
            },
            child: Text(
              appLocalizations.open_app_settings,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationServiceDisabledWidget() {
    return _buildErrorWidget(
      AppLocalizations.of(Get.context!)!.error_location_disabled,
      () {
        controller.locationInit();
      },
      key: const Key("main_screen_location_service_disabled_widget"),
    );
  }

  Widget _buildGradientWidget() {
    return Container(
      key: const Key("main_screen_gradient_widget"),
      decoration: BoxDecoration(
        gradient: WidgetHelper.buildGradient(
          AppColors.nightStartColor,
          AppColors.nightEndColor,
        ),
      ),
    );
  }

  Widget _buildFailedToLoadDataWidget(ApplicationError error) {
    final appLocalizations = AppLocalizations.of(Get.context!)!;
    String detailedDescription = "";
    switch (error) {
      case ApplicationError.apiError:
        detailedDescription = appLocalizations.error_api;
        break;
      case ApplicationError.connectionError:
        detailedDescription = appLocalizations.error_server_connection;
        break;
      case ApplicationError.locationNotSelectedError:
        detailedDescription = appLocalizations.error_location_not_selected;
        break;
    }

    return _buildErrorWidget(
      "${appLocalizations.error_failed_to_load_weather_data} $detailedDescription",
      () {
        controller.selectWeatherData();
      },
      key: const Key("main_screen_failed_to_load_data_widget"),
    );
  }

  Widget _buildErrorWidget(
    String errorMessage,
    Function() onRetryClicked, {
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: onRetryClicked,
                  child: Text(
                    AppLocalizations.of(Get.context!)!.retry,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<PopupMenuElement> _getOverflowMenu(BuildContext context) {
    final applicationLocalization = AppLocalizations.of(context)!;
    final List<PopupMenuElement> menuList = [];
    menuList.add(PopupMenuElement(
      key: const Key("menu_overflow_settings"),
      title: applicationLocalization.settings,
    ));
    menuList.add(PopupMenuElement(
      key: const Key("menu_overflow_about"),
      title: applicationLocalization.about,
    ));
    return menuList;
  }

  Widget _buildOverflowMenuAppbar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: Colors.white,
      ),
      child: PopupMenuButton<PopupMenuElement>(
        onSelected: (PopupMenuElement element) {
          controller.onMenuElementClicked(element);
        },
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        itemBuilder: (BuildContext context) {
          return _getOverflowMenu(context).map((PopupMenuElement element) {
            return PopupMenuItem<PopupMenuElement>(
              value: element,
              child: Text(
                element.title!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:feather_jhomlala/data/model/internal/application_error.dart';
import 'package:feather_jhomlala/data/model/internal/unit.dart';
import 'package:feather_jhomlala/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather_jhomlala/data/model/remote/weather_response.dart';

abstract class MainState extends Equatable {
  final Unit? unit;

  const MainState({this.unit});

  @override
  List<Object?> get props => [unit];
}

class SuccessLoadMainScreenState extends MainState {
  final WeatherResponse weatherResponse;
  final WeatherForecastListResponse weatherForecastListResponse;

  const SuccessLoadMainScreenState(
    this.weatherResponse,
    this.weatherForecastListResponse,
  );

  @override
  List<Object?> get props => [unit, weatherResponse];
}

class LocationServiceDisabledMainScreenState extends MainState {}

class PermissionNotGrantedMainScreenState extends MainState {
  final bool permanentlyDeniedPermission;

  const PermissionNotGrantedMainScreenState(this.permanentlyDeniedPermission);
}

class FailedLoadMainScreenState extends MainState {
  final ApplicationError applicationError;

  const FailedLoadMainScreenState(this.applicationError);

  @override
  List<Object?> get props => [unit, applicationError];
}

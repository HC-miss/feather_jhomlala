import 'package:equatable/equatable.dart';
import 'package:feather_jhomlala/data/model/internal/unit.dart';

class SettingsState extends Equatable {
  final Unit unit;
  final int refreshTime;
  final int lastRefreshTime;

  SettingsState(
      {required this.unit,
      required this.refreshTime,
      required this.lastRefreshTime});

  SettingsState copyWith({
    Unit? unit,
    int? refreshTime,
    int? lastRefreshTime,
  }) {
    return SettingsState(
      unit: unit ?? this.unit,
      refreshTime: refreshTime ?? this.refreshTime,
      lastRefreshTime: lastRefreshTime ?? this.lastRefreshTime,
    );
  }

  @override
  List<Object?> get props => [unit, refreshTime, lastRefreshTime];

  @override
  bool get stringify => true;
}

import 'package:feather_jhomlala/data/model/internal/unit.dart';
import 'package:feather_jhomlala/data/providers/app_local_provider.dart';

class AppLocalRepository {
  final AppLocalProvider appLocalProvider;

  AppLocalRepository(this.appLocalProvider);

  Unit getSavedUnit() {
    return appLocalProvider.getUnit();
  }

  void saveUnit(Unit unit) {
    appLocalProvider.saveUnit(unit);
  }

  int getSavedRefreshTime() {
    return appLocalProvider.getRefreshTime();
  }

  void saveRefreshTime(int refreshTime) {
    appLocalProvider.saveRefreshTime(refreshTime);
  }

  int getLastRefreshTime() {
    return appLocalProvider.getLastRefreshTime();
  }

  void saveLastRefreshTime(int lastRefreshTime) {
    appLocalProvider.saveLastRefreshTime(lastRefreshTime);
  }
}

import 'package:feather_jhomlala/data/providers/app_local_provider.dart';
import 'package:feather_jhomlala/data/repositories/app_local_repository.dart';
import 'package:get/get.dart';

import 'settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SettingsController(
        appLocalRepository: AppLocalRepository(AppLocalProvider()),
      ),
    );
  }
}

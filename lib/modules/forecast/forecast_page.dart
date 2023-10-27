import 'package:feather_jhomlala/widgets/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forecast_controller.dart';

class ForecastPage extends GetView<ForecastController> {
  const ForecastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.parameters
    // Get.arguments
    // Get.toNamed(page)
    return Scaffold(
      body: Stack(
        children: [
          TransparentAppBar(
            withPopupMenu: true,
            onPopupMenuClicked: controller.onMenuElementClicked,
          )
        ],
      ),
    );
  }
}

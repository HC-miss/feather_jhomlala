import 'package:feather_jhomlala/core/values/app_assets.dart';
import 'package:feather_jhomlala/widgets/animated_gradient.dart';
import 'package:feather_jhomlala/widgets/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'about_controller.dart';

class AboutPage extends GetView<AboutController> {
  final List<Color> startGradientColors;

  const AboutPage({Key? key, this.startGradientColors = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedGradientWidget(
            duration: const Duration(seconds: 3),
            startGradientColors: startGradientColors,
          ),
          SafeArea(
            child: Stack(
              children: [
                Container(
                  key: const Key("weather_main_screen_container"),
                  child: _buildMainWidget(context),
                ),
                const TransparentAppBar(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMainWidget(BuildContext context) {
    final applicationLocalization = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogoWidget(),
          Text(
            'feather',
            key: const Key("about_screen_app_name"),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          _buildVersionWidget(),
          const SizedBox(height: 20),
          Text(
            '${applicationLocalization.contributors}:',
            key: const Key("about_screen_contributors"),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          const Text("Jakub Homlala (jhomlala)"),
          const SizedBox(height: 20),
          Text(
            "${applicationLocalization.credits}:",
            key: const Key("about_screen_credits"),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Text(applicationLocalization.weather_data),
          const SizedBox(height: 2),
          Text(applicationLocalization.icon_data)
        ],
      ),
    );
  }

  Widget _buildVersionWidget() {
    return FutureBuilder<String>(
      future: _getVersionAndBuildNumber(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            key: const Key("about_screen_app_version_and_build"),
            style: Theme.of(context).textTheme.titleSmall,
          );
        }
        return Container(
          key: const Key("about_screen_app_version_and_build"),
        );
      },
    );
  }

  Future<String> _getVersionAndBuildNumber() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version} (${packageInfo.buildNumber})";
  }

  Widget _buildLogoWidget() {
    return Material(
      type: MaterialType.circle,
      clipBehavior: Clip.hardEdge,
      color: Colors.white10,
      child: InkWell(
        onTap: () => _onLogoClicked(),
        child: Image.asset(
          AppAssetsImages.iconLogoPng,
          fit: BoxFit.fill,
          key: const Key("about_screen_logo"),
          width: 256,
          height: 256,
        ),
      ),
    );
  }

  void _onLogoClicked() async {
    final uri = Uri.parse('https://github.com/HC-miss');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

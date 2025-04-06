import 'package:apps/utils/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/assets.dart';
import '../../../utils/component/cached_image_widget.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scaffoldBackgroundColor: Colors.black,
      hideAppBar: true,
      isLoading: splashController.isLoading,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          // Center(child: Text("Splash"))
          Hero(
            tag: Assets.appLogo,
            child: CachedImageWidget(
              url: Assets.appLogo,
              height: 200,
              width: 200,
            ),
          ),

        ],
      ),
    );
  }
}

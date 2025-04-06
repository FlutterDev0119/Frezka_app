import 'dart:ui';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';



class LoaderWidget extends StatelessWidget {
  final bool isBlurBackground;
  final Color? loaderColor;
  final double? size;

  const LoaderWidget({super.key, this.loaderColor, this.size, this.isBlurBackground = false});

  @override
  Widget build(BuildContext context) {
    return isBlurBackground
        ? AbsorbPointer(
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0, tileMode: TileMode.mirror),
                child: Lottie.asset(Assets.lottiesAppLoaderLottie, height: 40, width: 40),
              ),
            ),
          )
        : Lottie.asset(Assets.lottiesAppLoaderLottie, height: 300, width: 300);
  }
}

class VoiceSearchLoadingWidget extends StatelessWidget {
  const VoiceSearchLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(Assets.lottiesVoiceSearchLoader, height: 150, repeat: true);
  }
}
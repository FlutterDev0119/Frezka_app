import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import 'loader_widget.dart';

class AppBody extends StatelessWidget {
  final Widget child;
  final RxBool isLoading;

  final RxInt currentPage;

  const AppBody({
    Key? key,
    required this.isLoading,
    required this.child,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          Obx(
            () => currentPage == 1
                ? const LoaderWidget().center().visible(isLoading.value)
                : Positioned(
                    bottom: 40,
                    left: 16,
                    right: 16,
                    child: const LoaderWidget(),
                  ).visible(isLoading.value),
          ),
        ],
      ),
    );
  }
}
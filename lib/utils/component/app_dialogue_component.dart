import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../generated/assets.dart';
import '../common/colors.dart';
import 'app_widgets.dart';
import 'cached_image_widget.dart';

class AppDialogueComponent extends StatelessWidget {
  final double? dialogueHeight;
  final String? confirmationImage;

  final Color? confirmationImageColor;
  final VoidCallback onConfirm;
  final String? titleText;
  final String? subTitleText;
  final String? confirmText;
  final String? cancelText;

  final Widget? child;

  const AppDialogueComponent({
    Key? key,
    this.dialogueHeight,
    required this.onConfirm,
    this.confirmationImage,
    this.titleText,
    this.subTitleText,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmationImageColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: boxDecorationDefault(
        color: appDashBoardCardColor,
        borderRadius: radiusOnly(
          topLeft: defaultRadius,
          topRight: defaultRadius,
        ),
      ),
      child: AnimatedCrossFade(
        crossFadeState: CrossFadeState.showFirst,
        duration: Duration(milliseconds: 100),
        firstChild: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            12.height,
            child ??
                CachedImageWidget(
                  url: confirmationImage ?? Assets.imagesIcConfirmation,
                  height: 35,
                  width: 35,
                  color: confirmationImage != null ? confirmationImageColor : appPrimaryColor,
                ),
            24.height,
            Text(
              titleText ?? "Do you want to perform this action?",
              style: boldTextStyle(size: 16),
              textAlign: TextAlign.center,
            ),
            if (subTitleText.validate().isNotEmpty) ...[
              12.height,
              Text(
                subTitleText.validate(),
                style: secondaryTextStyle(),
                textAlign: TextAlign.center,
              ),
            ],
            24.height,
            Row(
              spacing: 16,
              children: [
                AppButtonWidget(
                  elevation: 0,
                  text: cancelText,
                  buttonColor: appBarBackgroundColorGlobal,
                  textStyle: boldTextStyle(),
                  onTap: () => Get.back(),
                ).expand(),
                AppButtonWidget(
                  elevation: 0,
                  buttonColor: appBackGroundColor,
                  text: confirmText,
                  onTap: () {
                    Get.back(result: true);
                    onConfirm.call();
                  },
                ).expand(),
              ],
            ).paddingOnly(bottom: 10),
          ],
        ),
        secondChild: SizedBox.shrink(), // Cleaner alternative to Offstage()
      ),
    );
  }
}

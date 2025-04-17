import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../generated/assets.dart';
import '../common/colors.dart';

class NoDataComponent extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? noDataImage;
  final double imageSize;
  final String? retryText;
  final VoidCallback? onRetry;

  const NoDataComponent({
    Key? key,
    this.title = 'No Data Found',
    this.subTitle = '',
    this.noDataImage,
    this.onRetry,
    this.retryText,
    this.imageSize = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.6,
      child: NoDataWidget(
        title: title,
        titleTextStyle: boldTextStyle(),
        subTitle: subTitle,
        subTitleTextStyle: secondaryTextStyle(),
        buttonPadding: EdgeInsets.zero,
        image: noDataImage ?? Assets.imagesIcNoDataImage,
        imageSize: Size(80, 80),
        retryText: retryText ?? "refresh",
        retryButtonTextColor: darkModePrimaryTextColor,
        onRetry: onRetry,
      ),
    );
  }
}
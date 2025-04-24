import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../generated/assets.dart';
import '../common/common.dart';
import '../constants.dart';
import 'cached_image_widget.dart';

class ImageSourceSelectionComponent extends StatelessWidget {
  final Function(ImageSource imageSource) onSourceSelected;

  const ImageSourceSelectionComponent({
    super.key,
    required this.onSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(
        color: context.cardColor,
      ),
      padding: EdgeInsets.all(16),
      child: AnimatedWrap(
        spacing: DefaultConstants.commonSectionSpaceRegular,
        runSpacing: DefaultConstants.commonSectionSpaceRegular,
        listAnimationType: commonListAnimationType,
        slideConfiguration: SlideConfiguration(
          curve: Curves.easeInOutCirc,
          duration: Duration(milliseconds: 800),
        ),
        children: <Widget>[
          Text('Choose Image Source', style: boldTextStyle(size: DefaultConstants.labelTextSize)),
          SettingItemWidget(
            title: 'Gallery',
            leading: CachedImageWidget(
              url: Assets.iconsIcGallery,
              height: 16,
              width: 16,
            ),
            decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Get.back();
              onSourceSelected.call(ImageSource.gallery);
            },
          ),
          // SettingItemWidget(
          //   title: 'Camera',
          //   leading: CachedImageWidget(
          //     url: Assets.iconsIcCamera,
          //     height: 16,
          //     width: 16,
          //   ),
          //   decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
          //   hoverColor: Colors.transparent,
          //   highlightColor: Colors.transparent,
          //   splashColor: Colors.transparent,
          //   onTap: () {
          //     Get.back();
          //     onSourceSelected.call(ImageSource.camera);
          //   },
          // ),
          Text(
            'Support: JPG,PNG,JPEG and up 5mb size',
            style: secondaryTextStyle(color: Colors.red, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
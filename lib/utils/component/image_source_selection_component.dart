import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../generated/assets.dart';
import '../common/common.dart';
import '../constants.dart';
import 'cached_image_widget.dart';

class ImageSourceSelectionComponent extends StatelessWidget {
  // final Function(ImageSource imageSource) onSourceSelected;
  final void Function(dynamic source) onSourceSelected;

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
          Text('Choose File Source', style: boldTextStyle(size: DefaultConstants.labelTextSize)),
          SettingItemWidget(
            title: 'File',
            leading: CachedImageWidget(
              url: Assets.iconsIcFile,
              height: 16,
              width: 16,
            ),
            decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            // onTap: () {
            //   Get.back();
            //   onSourceSelected.call(ImageSource.gallery);
            // },
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['xml', 'pdf', 'docx', 'xlsx', 'xls', 'csv', 'txt', 'png', 'jpg'],
              );

              if (result != null && result.files.single.path != null) {
                File file = File(result.files.single.path!);
                Get.back();
                onSourceSelected.call(file); // Custom callback

              }
            },

            // onTap: () async {
            //   Get.back();
            //   FilePickerResult? result = await FilePicker.platform.pickFiles(
            //     type: FileType.custom,
            //     allowedExtensions: ['xml', 'pdf', 'docx', 'xlsx', 'xls', 'csv', 'txt', 'png', 'jpg']
            //   );
            //
            //   if (result != null && result.files.single.path != null) {
            //     File file = File(result.files.single.path!);
            //     // Do something with the selected file
            //     print('Picked file: ${file.path}');
            //     // You can also pass the file to your onSourceSelected callback if modified accordingly
            //   } else {
            //     // User canceled the picker
            //   }
            // },

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
          // Text(
          //   'Support: JPG,PNG,JPEG and up 5mb size',
          //   style: secondaryTextStyle(color: Colors.red, fontStyle: FontStyle.italic),
          // ),
        ],
      ),
    );
  }
}
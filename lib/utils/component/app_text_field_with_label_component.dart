import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants.dart';

class AppTextFieldWithLabelComponent extends StatelessWidget {
  final String label;
  final bool isRequiredField;
  final Widget appTextField;

  const AppTextFieldWithLabelComponent({
    Key? key,
    required this.label,
    this.isRequiredField = false,
    required this.appTextField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: DefaultConstants.commonSectionSpaceMedium,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: label, style: boldTextStyle(size: 14)),
              if (isRequiredField) TextSpan(text: ' *', style: boldTextStyle(size: 14, color: Colors.red)),
            ],
          ),
        ),
        appTextField,
      ],
    );
  }
}

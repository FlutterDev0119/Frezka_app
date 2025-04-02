import 'package:apps/utils/library.dart';
import 'package:nb_utils/nb_utils.dart';

InputDecoration inputDecoration(
    BuildContext context, {
      Widget? prefixIcon,
      EdgeInsetsGeometry? contentPadding,
      BoxConstraints? prefixIconConstraints,
      BoxConstraints? suffixIconConstraints,
      Widget? suffixIcon,
      String? labelText,
      String? hintText,
      double? borderRadius,
      bool? filled,
      Color? fillColor,
    }) {
  labelText = hintText;
  return InputDecoration(
    contentPadding: contentPadding ?? const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    counterText: "",
    // hintText: hintText,
    hintStyle: secondaryTextStyle(size: 12, color: secondaryTextColor.withOpacity(0.6)),
    labelStyle: secondaryTextStyle(size: 12, color: secondaryTextColor.withOpacity(0.6)),
    alignLabelWithHint: false,
    prefixIcon: prefixIcon,
    prefixIconConstraints: prefixIconConstraints,
    suffixIcon: suffixIcon,
    suffixIconConstraints: suffixIconConstraints,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius / 2),
      borderSide: const BorderSide(color: lightGray, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius / 2),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius / 2),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius / 2),
      borderSide: const BorderSide(color: lightGray, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius / 2),
      borderSide: const BorderSide(color: lightGray, width: 0.0),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius / 2),
      borderSide: const BorderSide(color: appColorPrimary, width: 0.0),
    ),
    filled: filled,
    fillColor: fillColor,
  );
}

Widget commonLeadingWid({required String imgPath, Color? color, double size = 20}) {
  return Image.asset(
    imgPath,
    width: size,
    height: size,
    color: color,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) => Icon(
      Icons.now_wallpaper_outlined,
      size: size,
      color: color ?? appColorSecondary,
    ),
  );
}

TextStyle get appButtonTextStyleGray => boldTextStyle(color: appColorSecondary, size: 14);
TextStyle get appButtonTextStyleWhite => boldTextStyle(color: Colors.white, size: 16);
TextStyle get appButtonPrimaryColorText => boldTextStyle(color: appColorPrimary);
TextStyle get appButtonFontColorText => boldTextStyle(color: Colors.grey, size: 14);


//Input Decoration Without FUll Border Only Underline border show
InputDecoration inputDecorationWithUnderlineBorder(
  BuildContext context, {
  Widget? prefixIcon,
  EdgeInsetsGeometry? contentPadding,
  BoxConstraints? prefixIconConstraints,
  BoxConstraints? suffixIconConstraints,
  Widget? suffixIcon,
  String? labelText,
  String? hintText,
  double? borderRadius,
  bool? filled,
  Color? fillColor,
}) {
  labelText = hintText;
  return InputDecoration(
    contentPadding: contentPadding ?? const EdgeInsets.only(left: 0, bottom: 10, top: 18, right: 10),
    // labelText: labelText,
    counterText: "",
    hintText: hintText,
    hintStyle: secondaryTextStyle(size: 12, color: secondaryTextColor.withOpacity(0.9)),
    labelStyle: secondaryTextStyle(size: 12, color: secondaryTextColor.withOpacity(0.9)),
    alignLabelWithHint: false,
    prefixIconConstraints: prefixIconConstraints?? const BoxConstraints(maxWidth: 0),
    prefixIcon: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: prefixIcon,
    ),
    suffixIcon: suffixIcon,
    suffixIconConstraints: suffixIconConstraints,
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: borderColorDark, width: 0.6),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: appColorPrimary, width: 2),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    border: const UnderlineInputBorder(
      borderSide: BorderSide(color: borderColorDark, width: 0.6),
    ),
    disabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: borderColorDark, width: 0.6),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: appColorPrimary, width:2),
    ),
    filled: filled,
    fillColor: fillColor,
  );
}
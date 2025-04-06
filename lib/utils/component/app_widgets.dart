import 'package:nb_utils/nb_utils.dart';

import '../common/common_base.dart';
import '../constants.dart';
import '../library.dart';
import 'cached_image_widget.dart';
Widget AppButtonWidget({
  ValueKey? key,
  VoidCallback? onTap,
  String? text,
  double? width,
  Color? buttonColor,
  Color? textColor,
  Color? disabledColor,
  Color? focusColor,
  Color? hoverColor,
  Color? splashColor,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  TextStyle? textStyle,
  ShapeBorder? shapeBorder,
  Widget? child,
  double? elevation,
  double? height,
  bool enabled = true,
  bool enableScaleAnimation = true, // Default true for animation
  Color? disabledTextColor,
  double? hoverElevation,
  double? focusElevation,
  double? highlightElevation,
  RxBool? isLoading,
}) {
  bool isBtnLoading = isLoading?.value ?? false; // Ensure correct RxBool handling

  return GestureDetector(
    onTap: enabled && !isBtnLoading ? onTap : null,
    child: AnimatedScale(
      scale: enableScaleAnimation && enabled && !isBtnLoading ? 1.0 : 0.95, // Tap animation
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: AppButton(
        key: key,
        padding: padding,
        margin: margin,
        color: buttonColor ?? appColorPrimary,
        splashColor: splashColor ?? Colors.transparent,
        hoverElevation: hoverElevation ?? 0.4,
        focusElevation: focusElevation ?? 0.5,
        highlightElevation: highlightElevation ?? 0.6,
        hoverColor: hoverColor ?? Colors.transparent,
        width: width ?? Get.width - 32,
        height: height ?? 50,
        // Adjust height for better visibility
        shapeBorder: shapeBorder,
        text: text,
        textColor: primaryTextColor,
        // textColor: textColor ?? (isDarkMode.value ? primaryTextColor : textPrimaryColorGlobal),
        disabledColor:  appColorPrimary,
        // disabledColor: disabledColor ?? (isDarkMode.value ? appDarkCardColor : widgetBackgroundColor),
        textStyle: textStyle ??
            buttonTextStyle(
              textColor: textColor ?? (darkModePrimaryTextColor),
            ),
        onTap: onTap,
        child: isBtnLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor ?? Colors.white),
          ),
        )
            : child,
        enabled: enabled && !isBtnLoading,
      ),
    ),
  );
}

Widget AppIconWidget({
  Object? tagKey,
  double iconSize = DefaultConstants.iconSize,
  EdgeInsets? padding,
  String? imageIcon,
  IconData? icon,
  Color? color,
  BoxFit? boxFit,
  bool isCircle = false,
}) {
  Widget content;

  if (imageIcon != null) {
    content = CachedImageWidget(
      url: imageIcon,
      height: iconSize,
      width: iconSize,
      fit: boxFit,
      color: color ?? iconColor,
      circle: isCircle,
    );

    // Add Hero only if `tagKey` is provided and no existing Hero ancestor is found
    if (tagKey != null) {
      content = Hero(
        tag: tagKey,
        child: content,
      );
    }
  } else {
    content = Icon(
      icon,
      color: color ?? iconColor,
      size: iconSize,
    );
  }

  return content;
}


Widget backButton({Object? result, double size = 20, EdgeInsets? padding}) {
  return IconButton(
    padding: padding ?? EdgeInsets.zero,
    onPressed: () {
      Get.back(result: result);
    },
    icon: Icon(Icons.arrow_back_ios_new_outlined, color: iconColor, size: size),
  );
}

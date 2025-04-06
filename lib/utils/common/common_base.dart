import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:nb_utils/nb_utils.dart';
import 'colors.dart';

InputDecoration appInputDecoration({
  required BuildContext context,
  Widget? prefixIcon,
  EdgeInsetsGeometry? contentPadding,
  BoxConstraints? prefixIconConstraints,
  BoxConstraints? suffixIconConstraints,
  Widget? suffixIcon,
  String? labelText,
  String? hintText,
  double? borderRadius,
  bool filled = true,
  Color? fillColor,
  TextStyle? labelStyle,
  TextStyle? hintStyle,
  InputBorder? border,
  InputBorder? focusedBorder,
}) {
  return InputDecoration(
    contentPadding: contentPadding ?? const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    hintText: hintText,
    hintStyle: hintStyle ?? secondaryTextStyle(size: 12),
    labelStyle: labelStyle ?? secondaryTextStyle(size: 12),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    prefixIconConstraints: prefixIconConstraints,
    suffixIcon: suffixIcon,
    suffixIconConstraints: suffixIconConstraints,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: lightIconColor, width: 0.85),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    ),
    errorMaxLines: 2,
    border: border ??
        OutlineInputBorder(
          borderRadius: radius(borderRadius ?? defaultRadius),
          borderSide: const BorderSide(color: lightIconColor, width: 1),
        ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: lightIconColor, width: 1),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: focusedBorder ??
        OutlineInputBorder(
          borderRadius: radius(borderRadius ?? defaultRadius),
          borderSide: const BorderSide(color: appPrimaryColor, width: 1),
        ),
    filled: filled,
    fillColor: fillColor ?? context.cardColor,
  );
}

TextStyle buttonTextStyle({
  Color? textColor,
  int? fontSize,
  FontStyle? fontStyle,
}) {
  return boldTextStyle(
    color: textColor ?? (darkModePrimaryTextColor),
    size: fontSize ?? 16,
    weight: FontWeight.w700,
    fontStyle: fontStyle,
  );
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodType = "",
  bool hasRequest = false,
  bool fullLog = false,
  String responseHeader = '',
}) {
  // fullLog = statusCode.isSuccessful();
  if (fullLog) {
    debugPrint("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    debugPrint("\u001b[93m Url: \u001B[39m $url");
    debugPrint("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    debugPrint("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (hasRequest) {
      debugPrint('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    debugPrint(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    debugPrint("\u001b[93m Response header: \u001B[39m \u001b[96m$responseHeader\u001B[39m");
    debugPrint('\u001b[93m MethodType ($methodType) | StatusCode ($statusCode)\u001B[39m');
    debugPrint('Response : ');
    debugPrint('\x1B[32m${formatJson(responseBody)}\x1B[0m');
    debugPrint("\u001B[0m");
    debugPrint("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  } else {
    debugPrint("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    debugPrint("\u001b[93m Url: \u001B[39m $url");
    debugPrint("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    debugPrint("\u001b[93m header: \u001B[39m \u001b[96m${headers.split(',').join(',\n')}\u001B[39m");
    if (hasRequest) {
      debugPrint('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    debugPrint(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    debugPrint('\u001b[93m MethodType ($methodType) | statusCode: ($statusCode)\u001B[39m');
    debugPrint("\u001b[93m Response header: \u001B[39m \u001b[96m$responseHeader\u001B[39m");
    debugPrint('\u001b[93m Response \u001B[39m');
    debugPrint('$responseBody');
    debugPrint("\u001B[0m");
    debugPrint("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  }
}

String formatJson(String jsonStr) {
  try {
    final dynamic parsedJson = jsonDecode(jsonStr);
    const formatter = JsonEncoder.withIndent('  ');
    return formatter.convert(parsedJson);
  } on Exception catch (e) {
    log("\x1b[31m formatJson error ::-> ${e.toString()} \x1b[0m");
    return jsonStr;
  }
}

import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';
import 'package:nb_utils/nb_utils.dart';
import '../modules/login/model/google_social_login_model.dart';
import '../modules/login/model/login_model.dart';
import '../modules/login/model/otp_model.dart';
import 'api_end_point.dart';
import 'network_utils.dart';

class AuthServiceApis {
  static Future<UserData> createUser({required Map request}) async {
    return UserData.fromJson(await handleResponse(await buildHttpResponse(
        APIEndPoints.register,
        request: request,
        method: HttpMethodType.POST)));
  }

  static Future<UserData> loginUser({required Map request}) async {
    return UserData.fromJson(await handleResponse(await buildHttpResponse(
        APIEndPoints.login,
        request: request,
        method: HttpMethodType.POST)));
  }

  static Future<OtpResponse> sendOTP({required Map request}) async {
    return OtpResponse.fromJson(await handleResponse(await buildHttpResponse(
        APIEndPoints.sendOTP,
        request: request,
        method: HttpMethodType.POST)));
  }

  // static Future<SocialLoginResponse> googleSocialLogin(
  //     {required Map request}) async {
  //   return SocialLoginResponse.fromJson(await handleResponse(
  //       await buildHttpResponse(APIEndPoints.socialLogin,
  //           request: request, method: HttpMethodType.POST)));
  // }

  // Clear  Data
  static Future<void> clearData({bool isFromDeleteAcc = false}) async {}

}
import 'package:nb_utils/nb_utils.dart';

import 'package:apps/utils/library.dart';

class AuthServiceApis {

  static Future<UserData> loginUser({required Map request}) async {
    return UserData.fromJson(await handleResponse(await buildHttpResponse(
        APIEndPoints.login,
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

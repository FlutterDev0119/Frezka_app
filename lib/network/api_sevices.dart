import 'package:nb_utils/nb_utils.dart';

import 'package:apps/utils/library.dart';

import '../utils/common/base_response_model.dart';
import '../utils/common/common.dart';
import '../utils/constants.dart';
import '../utils/shared_prefences.dart';

class AuthServiceApis {
  static Future<String?> login({
    required Map<String, dynamic> request,
    bool isSocialLogin = false,
  }) async {
    UserDataResponseModel userDataResponse =
        await UserDataResponseModel.fromJson(
      await buildHttpResponse(
        endPoint: isSocialLogin ? APIEndPoints.socialLogin : APIEndPoints.login,
        request: request,
        method: MethodType.post,
      ),
    );

    isLoggedIn(true);
    setValue(AppSharedPreferenceKeys.isSocialLogin, isSocialLogin);
    loggedInUser(userDataResponse);
    apiToken = userDataResponse.access!;
    setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
    setValue(
        AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());
    setValue(AppSharedPreferenceKeys.apiToken, loggedInUser.value.access);
    setValue(
        AppSharedPreferenceKeys.userEmail, userDataResponse.userModel?.email);
    setValue(AppSharedPreferenceKeys.userPassword,
        request[ConstantKeys.passwordKey]);
    // cachedDashboardData = null;
    // if (!isSocialLogin) SocialLoginService.loginWithEmailPassword();
    return userDataResponse.refresh;
  }

  static Future<BaseResponseModel> forgotPassword({required Map<String, dynamic> request}) async {
    return await BaseResponseModel.fromJson(
      await buildHttpResponse(
        endPoint: APIEndPoints.forgotPassword,
        request: request,
        method: MethodType.post,
      ),
    );
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

import 'package:nb_utils/nb_utils.dart';

import 'package:apps/utils/library.dart';

import '../modules/login/model/google_social_login_model.dart';
import '../modules/prompt_admin/model/inherit_fetch_doc_model.dart';
import '../utils/common/base_response_model.dart';
import '../utils/common/common.dart';
import '../utils/constants.dart';
import '../utils/shared_prefences.dart';

class AuthServiceApis {
  static Future<String?> login({
    required Map<String, dynamic> request,
  }) async {
    UserDataResponseModel userDataResponse = await UserDataResponseModel.fromJson(
      await buildHttpResponse(
        endPoint: APIEndPoints.login,
        request: request,
        method: MethodType.post,
      ),
    );

    isLoggedIn(true);
    loggedInUser(userDataResponse);
    apiToken = userDataResponse.access!;
    setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
    setValue(AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());
    setValue(AppSharedPreferenceKeys.apiToken, loggedInUser.value.access);
    setValue(AppSharedPreferenceKeys.userEmail, userDataResponse.userModel?.email);
    setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
    // cachedDashboardData = null;
    // if (!isSocialLogin) SocialLoginService.loginWithEmailPassword();
    return userDataResponse.refresh;
  }

  // static Future<BaseResponseModel> forgotPassword({required Map<String, dynamic> request}) async {
  //   return await BaseResponseModel.fromJson(
  //     await buildHttpResponse(
  //       endPoint: APIEndPoints.forgotPassword,
  //       request: request,
  //       method: MethodType.post,
  //     ),
  //   );
  // }
  static Future<BaseResponseModel> forgotPassword({required Map<String, dynamic> request}) async {
    try {
      final responseJson = await buildHttpResponse(
        endPoint: APIEndPoints.forgotPassword,
        request: request,
        method: MethodType.post,
      );

      if (responseJson == null || responseJson is! Map<String, dynamic>) {
        throw Exception("Unexpected response from server");
      }

      return BaseResponseModel.fromJson(responseJson);
    } catch (e) {
      // You can customize this error model or throw the error if needed
      return BaseResponseModel(
        message: e.toString(),
        statusCode: 500,
        data: null,
      );
    }
  }


  static Future<SocialLoginResponse> googleSocialLogin({required Map request}) async {
    return SocialLoginResponse.fromJson(
        await handleResponse(await buildHttpResponse(endPoint: APIEndPoints.socialLogin, request: request, method: MethodType.post)));
  }

  // Clear  Data
  static Future<void> clearData({bool isFromDeleteAcc = false}) async {}
}

class PromptAdminServiceApis {
  static Future<PromptInherit?> getPromptInherit() async {
    List<String> params = [];

    try {
      final response = await buildHttpResponse(
        endPoint: getEndPoint(
          endPoint: APIEndPoints.fetchDoc,
          params: params,
        ),
      );

      return PromptInherit.fromJson(response);
    } catch (e) {
      toast(e.toString());
      print("Error fetching prompt inherit: $e");
      return null;
    }
  }
}

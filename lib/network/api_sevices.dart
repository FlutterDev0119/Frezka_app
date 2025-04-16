import 'package:nb_utils/nb_utils.dart';

import 'package:apps/utils/library.dart';

import '../modules/login/model/google_social_login_model.dart';
import '../modules/meta_phrase_pv/model/open_worklist_model.dart';
import '../modules/meta_phrase_pv/model/transalted_model.dart';
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
    setValueToLocal(AppSharedPreferenceKeys.isUserLoggedIn, true);
    setValueToLocal(AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());
    setValueToLocal(AppSharedPreferenceKeys.apiToken, loggedInUser.value.access);
    setValueToLocal(AppSharedPreferenceKeys.userEmail, "sandesh.singhal@pvanalytica.com"); //userDataResponse.userModel?.email
    setValueToLocal(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
    // setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
    // setValue(AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());
    // setValue(AppSharedPreferenceKeys.apiToken, loggedInUser.value.access);
    // setValue(AppSharedPreferenceKeys.userEmail, userDataResponse.userModel?.email);
    // setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
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

/// PROMPT ADMIN
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

/// META PHRASE PV
class MetaPhrasePVServiceApis {
  static Future<List<TranslationWork>> fetchMetaPhraseList() async {
      final response = await buildHttpResponse(
        endPoint: APIEndPoints.openWorklist,
        method: MethodType.get,
      );

      // Ensure response is a List and map it properly
      if (response is List) {
        return response.map((e) => TranslationWork.fromMap(e)).toList();
      } else {
        throw Exception('Unexpected response format: ${response.runtimeType}');
      }
    }

  static Future<List<TranslationReport>> fetchMetaPhraseListById(String id) async {
    try {
      // Make the API call
      final response = await buildHttpResponse(
        endPoint: "${APIEndPoints.openWorklist}?Id=$id",
        method: MethodType.get,
      );

      // Check if the response is a List of TranslationReport objects
      if (response is List) {
        // If the response is already a list, map it directly to TranslationReport
        return response
            .map((e) => TranslationReport.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (response is Map<String, dynamic>) {
        // If the response is a Map, handle it accordingly
        return [TranslationReport.fromJson(response)];
      } else {
        throw FormatException('Unexpected response type: ${response.runtimeType}');
      }
    } catch (e) {
      print('Error fetching translation report for id $id: $e');
      throw Exception('Failed to fetch translation report for id $id: $e');
    }
  }





}

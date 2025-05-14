// import 'dart:convert';
// import 'dart:io';
// import 'package:apps/modules/login/model/login_model.dart';
// import 'package:get/get.dart' as get_state;
// import 'package:http/http.dart';
// import 'package:nb_utils/nb_utils.dart';
//
// import '../utils/common/common.dart';
// import '../utils/common/common_base.dart';
// import '../utils/constants.dart';
// import '../utils/shared_prefences.dart';
// import 'api_end_point.dart';
// import 'api_sevices.dart';
// import 'config.dart';
//
// Map<String, String> defaultHeaders() {
//   Map<String, String> header = {};
//
//   header.putIfAbsent(HttpHeaders.cacheControlHeader, () => 'no-cache');
//   header.putIfAbsent('Access-Control-Allow-Headers', () => '*');
//   header.putIfAbsent('Access-Control-Allow-Origin', () => '*');
//
//   return header;
// }
//
// Map<String, String> buildHeaderTokens() {
//   Map<String, String> header = {};
//
//   if (isLoggedIn.value) {
//     final headerToken = loggedInUser.value.access!.isNotEmpty
//         ? loggedInUser.value.access
//         : getStringAsync(AppSharedPreferenceKeys.apiToken).isNotEmpty
//             ? getStringAsync(AppSharedPreferenceKeys.apiToken)
//             : '';
//     if (headerToken!.isNotEmpty) header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${headerToken}');
//   }
//
//   header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
//   header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json; charset=utf-8');
//   header.addAll(defaultHeaders());
//
//   return header;
// }
//
// Uri buildBaseUrl(String endPoint) {
//   if (!endPoint.startsWith('http')) {
//     return Uri.parse('$BASE_URL$endPoint');
//   } else {
//     return Uri.parse(endPoint);
//   }
// }
//
// Future buildHttpResponse({
//   required String endPoint,
//   MethodType method = MethodType.get,
//   Map? request,
//   Map<String, String>? header,
//   bool retrying = false,
//   bool allowTokenRefresh = true,
// }) async {
//   var headers = header ?? buildHeaderTokens();
//   Uri url = buildBaseUrl(endPoint);
//   Response response;
//
//   try {
//     if (method == MethodType.post) {
//       response = await post(url, body: jsonEncode(request), headers: headers);
//     } else if (method == MethodType.delete) {
//       response = await delete(url, headers: headers);
//     } else if (method == MethodType.put) {
//       response = await put(url, body: jsonEncode(request), headers: headers);
//     } else {
//       response = await get(url, headers: headers);
//     }
//
//     apiPrint(
//       url: url.toString(),
//       endPoint: endPoint,
//       headers: jsonEncode(headers),
//       hasRequest: method == MethodType.post || method == MethodType.put,
//       request: jsonEncode(request),
//       statusCode: response.statusCode,
//       responseBody: response.body,
//       methodType: method.name,
//     );
//
//     if (response.statusCode == 401) {//isLoggedIn.value &&
//       bool tokenRegenerated = await reGenerateToken();
//
//       if (tokenRegenerated) {
//         return await handleResponse(
//           await buildHttpResponse(
//             endPoint: endPoint,
//             method: method,
//             request: request,
//             header: null,
//             allowTokenRefresh: false,
//           ),
//         );
//       }
//     } else {
//       return await handleResponse(response);
//     }
//   } on Exception {
//     throw errorInternetNotAvailable;
//   }
// }
//
// /// Multipart request
// Future<MultipartRequest> buildMultiPartRequest(String endPoint, {String? baseUrl}) async {
//   String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
//   return MultipartRequest('POST', Uri.parse(url));
// }
//
// Future buildMultiPartResponse({
//   required String endPoint,
//   required Map<String, dynamic> request,
//   Map<String, String>? header,
//   List<File>? files,
//   String? fileKey,
//   bool isHelpDesk = false,
// }) async {
//   try {
//     MultipartRequest multiPartRequest = await buildMultiPartRequest(endPoint);
//     multiPartRequest.headers.addAll(buildHeaderTokens());
//     multiPartRequest.fields.addAll(await getMultipartFields(val: request));
//     if (files != null && files.isNotEmpty) {
//       files.removeWhere((element) => element.path.isEmpty);
//       if (files.length > 1) {
//         files.forEachIndexed(
//           (element, index) async {
//             print('${fileKey}_${index} : ${element.path}');
//             multiPartRequest.files.add(await MultipartFile.fromPath('${fileKey}_${index}', element.path));
//           },
//         );
//       } else if (files.length == 1) {
//         files.forEachIndexed(
//           (element, index) async {
//             if (isHelpDesk) {
//               print('${fileKey}_${index} : ${element.path}');
//               multiPartRequest.files.add(await MultipartFile.fromPath('${fileKey}_${index}', element.path));
//             } else {
//               print('${fileKey} : ${element.path}');
//               multiPartRequest.files.add(await MultipartFile.fromPath('${fileKey}', element.path));
//             }
//           },
//         );
//       }
//       if (files.validate().length > 0) multiPartRequest.fields.putIfAbsent(ConstantKeys.attachmentCountKey, () => files.validate().length.toString());
//     }
//
//     Response response = await Response.fromStream(await multiPartRequest.send());
//
//     apiPrint(
//       url: multiPartRequest.url.toString(),
//       headers: jsonEncode(multiPartRequest.headers),
//       request: jsonEncode(multiPartRequest.fields),
//       hasRequest: true,
//       statusCode: response.statusCode,
//       responseBody: response.body,
//       methodType: "MultiPart",
//     );
//     return await handleResponse(response);
//   } on SocketException catch (e) {
//     log(e.toString());
//   } on Exception catch (e) {
//     log(e.toString());
//   }
// }
//
// Future<void> handleFailRegenerateToken() async {
//   // await SocialLoginService.deleteCurrentFirebaseUser();
//   isLoggedIn(false);
//   loggedInUser(UserDataResponseModel());
//
//   setValue(AppSharedPreferenceKeys.isUserLoggedIn, false);
//   setValue(AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());
//   setValue(AppSharedPreferenceKeys.userEmail, '');
//   setValue(AppSharedPreferenceKeys.userPassword, '');
//   setValue(AppSharedPreferenceKeys.apiToken, '');
//   // setValue(AppSharedPreferenceKeys.cachedDashboardData, '');
//
//   get_state.Get.offAll(() => ());
// }
// Future<bool> reGenerateToken() async {
//   await setValue(AppSharedPreferenceKeys.isUserLoggedIn, false);
//   await setValue(AppSharedPreferenceKeys.apiToken, '');
//   await setValue(AppSharedPreferenceKeys.currentUserData, '');
//   await clearSharedPref();
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.clear();
//   log('Attempting to regenerate token');
//
//   final String email = getStringAsync(AppSharedPreferenceKeys.userEmail);
//   final String password = getStringAsync(AppSharedPreferenceKeys.userPassword);
//
//   if (email.isEmpty || password.isEmpty) {
//     log('Missing credentials, cannot regenerate token');
//     await handleFailRegenerateToken();
//     return false;
//   }
//
//   Map<String, dynamic> request = {
//     ConstantKeys.emailKey: email,
//     ConstantKeys.passwordKey: password,
//   };
//
//   try {
//     var loginResponse = await buildHttpResponse(
//       endPoint: APIEndPoints.login,
//       request: request,
//       method: MethodType.post,
//       allowTokenRefresh: false, // ⚠️ Important: Don't retry during login!
//     );
//
//     UserDataResponseModel userDataResponse = UserDataResponseModel.fromJson(loginResponse);
//
//     if (userDataResponse != null) {
//       loggedInUser(userDataResponse);
//       apiToken = userDataResponse.access!;
//       await setValue(AppSharedPreferenceKeys.apiToken, userDataResponse.access);
//       await setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
//       await setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
//       await setValue(AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());
//       await setValue(AppSharedPreferenceKeys.userEmail, request['email'].toString());
//       await setValue(AppSharedPreferenceKeys.userModel, jsonEncode(userDataResponse.userModel));
//       isLoggedIn(true);
//       return true;
//     } else {
//       await handleFailRegenerateToken();
//       return false;
//     }
//   } catch (e) {
//     log('Token regeneration failed: $e');
//     await handleFailRegenerateToken();
//     return false;
//   }
// }
//
// // Future<bool> reGenerateToken() async {
// //   log('Attempting to regenerate token');
// //
// //   // Do NOT clear shared preferences before retrieving stored credentials
// //   final String email = getStringAsync(AppSharedPreferenceKeys.userEmail);
// //   final String password = getStringAsync(AppSharedPreferenceKeys.userPassword);
// //
// //   if (email.isEmpty || password.isEmpty) {
// //     log('Missing credentials, cannot regenerate token');
// //     await handleFailRegenerateToken();
// //     return false;
// //   }
// //
// //   Map<String, dynamic> request = {
// //     ConstantKeys.emailKey: email,
// //     ConstantKeys.passwordKey: password,
// //   };
// //
// //   try {
// //     // final String? newToken = await AuthServiceApis.login(request: req);
// //     UserDataResponseModel userDataResponse = await UserDataResponseModel.fromJson(
// //         await buildHttpResponse(
// //           endPoint: APIEndPoints.login,
// //           request: request,
// //           method: MethodType.post,
// //           allowTokenRefresh: false,
// //         ));
// //     if (userDataResponse != null) {
// //       loggedInUser(userDataResponse);
// //       apiToken = userDataResponse.access!;
// //       await setValue(AppSharedPreferenceKeys.apiToken, userDataResponse.access);
// //       await setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
// //       await setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
// //       setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
// //       setValue(AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());
// //       setValue(AppSharedPreferenceKeys.apiToken, loggedInUser.value.access);
// //       setValue(AppSharedPreferenceKeys.userEmail, request['email'].toString()); //userDataResponse.userModel?.email
// //       setValue(AppSharedPreferenceKeys.userModel, jsonEncode(userDataResponse.userModel)); //userDataResponse.userModel?.email
// //       setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
// //       isLoggedIn(true);
// //       return true;
// //     } else {
// //       await handleFailRegenerateToken();
// //       return false;
// //     }
// //   } catch (e) {
// //     log('Token regeneration failed: $e');
// //     await handleFailRegenerateToken();
// //     return false;
// //   }
// // }
//
//
// Future handleResponse(Response response, {HttpResponseType httpResponseType = HttpResponseType.JSON}) async {
//   if (!await isNetworkAvailable()) {
//     throw errorInternetNotAvailable;
//   }
//   if (response.statusCode == 403) {
//     throw 'Page not found';
//   } else if (response.statusCode == 429) {
//     throw 'Too many requests';
//   } else if (response.statusCode == 500) {
//     var body = jsonDecode(response.body);
//     if (body is Map && body.containsKey('status') && body['status'] is bool && !body['status']) {
//       throw parseHtmlString(body['message'] ?? 'Internal server error');
//     } else {
//       throw 'Internal server error';
//     }
//   } else if (response.statusCode == 502) {
//     throw 'Bad gateway';
//   } else if (response.statusCode == 503) {
//     throw 'Service unavailable';
//   } else if (response.statusCode == 504) {
//     throw 'Gateway timeout';
//   } else {
//     if (response.statusCode.isSuccessful()) {
//       var body = jsonDecode(response.body);
//       if (body is Map && body.containsKey('status') && body['status'] is bool && !body['status']) {
//         throw parseHtmlString(body['message'] ?? errorSomethingWentWrong);
//       } else {
//         return body;
//       }
//     } else {
//       Map body = jsonDecode(response.body.trim());
//       Map<String, dynamic> errorData = {
//         'status_code': response.statusCode,
//         'status': false,
//         "response": body,
//         "message": body['message'] ?? body['error'] ?? errorSomethingWentWrong,
//       };
//
//       // Handle validation errors if present
//       if (body.containsKey('errors') && body['errors'] is Map) {
//         List<String> errorMessages = [];
//         body['errors'].forEach((key, value) {
//           if (value is List) {
//             errorMessages.addAll(value.map((e) => e.toString()));
//           }
//         });
//         if (errorMessages.isNotEmpty) {
//           errorData["message"] = errorMessages.join("\n");
//         }
//       }
//       throw errorData["message"];
//     }
//   }
// }
//
// //region CommonFunctions
// Future<Map<String, String>> getMultipartFields({required Map<String, dynamic> val}) async {
//   Map<String, String> data = {};
//
//   val.forEach((key, value) {
//     data[key] = '$value';
//   });
//
//   return data;
// }
//
//
// String getEndPoint({required String endPoint, int? perPages, int? page, List<String>? params}) {
//   List<String> queryParams = [];
//
//   // Add perPage and page only if they exist
//
//   // Append params if they exist
//
//   if (params != null && params.isNotEmpty) {
//     queryParams.addAll(params);
//   }
//   if (perPages != null) queryParams.add("per_page=${perPages}");
//   if (page != null) queryParams.add("page=$page");
//
//   return "$endPoint${queryParams.isNotEmpty ? '?${queryParams.join('&')}' : ''}";
// }
//
// //endregion
import 'dart:convert';
import 'dart:io';
import 'package:apps/modules/login/model/login_model.dart';
import 'package:get/get.dart' as get_state;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/common/common.dart';
import '../utils/common/common_base.dart';
import '../utils/constants.dart';
import '../utils/shared_prefences.dart';
import 'api_end_point.dart';
import 'api_sevices.dart';
import 'config.dart';

Map<String, String> defaultHeaders() {
  Map<String, String> header = {};

  header.putIfAbsent(HttpHeaders.cacheControlHeader, () => 'no-cache');
  header.putIfAbsent('Access-Control-Allow-Headers', () => '*');
  header.putIfAbsent('Access-Control-Allow-Origin', () => '*');

  return header;
}

Map<String, String> buildHeaderTokens() {
  Map<String, String> header = {};

  if (isLoggedIn.value) {
    final headerToken = loggedInUser.value.access!.isNotEmpty
        ? loggedInUser.value.access
        : getStringAsync(AppSharedPreferenceKeys.apiToken).isNotEmpty
        ? getStringAsync(AppSharedPreferenceKeys.apiToken)
        : '';
    if (headerToken!.isNotEmpty) header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${headerToken}');
  }

  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
  header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json; charset=utf-8');
  header.addAll(defaultHeaders());

  return header;
}

Uri buildBaseUrl(String endPoint) {
  if (!endPoint.startsWith('http')) {
    return Uri.parse('$BASE_URL$endPoint');
  } else {
    return Uri.parse(endPoint);
  }
}

Future buildHttpResponse({
  required String endPoint,
  MethodType method = MethodType.get,
  Map? request,
  Map<String, String>? header,
  bool retrying = false,
  bool allowTokenRefresh = true,
}) async {
  var headers = header ?? buildHeaderTokens();
  Uri url = buildBaseUrl(endPoint);
  Response response;

  try {
    if (method == MethodType.post) {
      response = await post(url, body: jsonEncode(request), headers: headers);
    } else if (method == MethodType.delete) {
      response = await delete(url, headers: headers);
    } else if (method == MethodType.put) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == MethodType.post || method == MethodType.put,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body,
      methodType: method.name,
    );

    if (response.statusCode == 401) {//isLoggedIn.value &&
      bool tokenRegenerated = await reGenerateToken();

      if (tokenRegenerated) {
        return await handleResponse(
          await buildHttpResponse(
            endPoint: endPoint,
            method: method,
            request: request,
            header: null,
            allowTokenRefresh: false,
          ),
        );
      }
    } else {
      return await handleResponse(response);
    }
  } on Exception {
    throw errorInternetNotAvailable;
  }
}

/// Multipart request
Future<MultipartRequest> buildMultiPartRequest(String endPoint, {String? baseUrl}) async {
  String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
  return MultipartRequest('POST', Uri.parse(url));
}

Future buildMultiPartResponse({
  required String endPoint,
  required Map<String, dynamic> request,
  Map<String, String>? header,
  List<File>? files,
  String? fileKey,
  bool isHelpDesk = false,
}) async {
  try {
    MultipartRequest multiPartRequest = await buildMultiPartRequest(endPoint);
    multiPartRequest.headers.addAll(buildHeaderTokens());
    multiPartRequest.fields.addAll(await getMultipartFields(val: request));
    if (files != null && files.isNotEmpty) {
      files.removeWhere((element) => element.path.isEmpty);
      if (files.length > 1) {
        files.forEachIndexed(
              (element, index) async {
            print('${fileKey}_${index} : ${element.path}');
            multiPartRequest.files.add(await MultipartFile.fromPath('${fileKey}_${index}', element.path));
          },
        );
      } else if (files.length == 1) {
        files.forEachIndexed(
              (element, index) async {
            if (isHelpDesk) {
              print('${fileKey}_${index} : ${element.path}');
              multiPartRequest.files.add(await MultipartFile.fromPath('${fileKey}_${index}', element.path));
            } else {
              print('${fileKey} : ${element.path}');
              multiPartRequest.files.add(await MultipartFile.fromPath('${fileKey}', element.path));
            }
          },
        );
      }
      if (files.validate().length > 0) multiPartRequest.fields.putIfAbsent(ConstantKeys.attachmentCountKey, () => files.validate().length.toString());
    }

    Response response = await Response.fromStream(await multiPartRequest.send());

    apiPrint(
      url: multiPartRequest.url.toString(),
      headers: jsonEncode(multiPartRequest.headers),
      request: jsonEncode(multiPartRequest.fields),
      hasRequest: true,
      statusCode: response.statusCode,
      responseBody: response.body,
      methodType: "MultiPart",
    );
    return await handleResponse(response);
  } on SocketException catch (e) {
    log(e.toString());
  } on Exception catch (e) {
    log(e.toString());
  }
}

Future<void> handleFailRegenerateToken() async {
  isLoggedIn(false);
  loggedInUser(UserDataResponseModel());
  apiToken = '';
  await setValue(AppSharedPreferenceKeys.isUserLoggedIn, false);
  await setValue(AppSharedPreferenceKeys.currentUserData, '');
  await setValue(AppSharedPreferenceKeys.userEmail, '');
  await setValue(AppSharedPreferenceKeys.userPassword, '');
  await setValue(AppSharedPreferenceKeys.apiToken, '');
  await setValue(AppSharedPreferenceKeys.userModel, '');
  // Optionally clear all shared preferences if needed
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  get_state.Get.offAll(() => ());
}
Future<bool> reGenerateToken() async {
  log('Attempting to regenerate token');

  // Do NOT clear shared preferences before retrieving stored credentials
  final String email = getStringAsync(AppSharedPreferenceKeys.userEmail);
  final String password = getStringAsync(AppSharedPreferenceKeys.userPassword);

  if (email.isEmpty || password.isEmpty) {
    log('Missing credentials, cannot regenerate token');
    await handleFailRegenerateToken();
    return false;
  }

  Map<String, dynamic> request = {
    ConstantKeys.emailKey: email,
    ConstantKeys.passwordKey: password,
  };

  try {
    var loginResponse = await buildHttpResponse(
      endPoint: APIEndPoints.login,
      request: request,
      method: MethodType.post,
      allowTokenRefresh: false, // Don't retry during login!
    );

    UserDataResponseModel userDataResponse = UserDataResponseModel.fromJson(loginResponse);

    if (userDataResponse != null && userDataResponse.access != null && userDataResponse.access!.isNotEmpty) {
      loggedInUser(userDataResponse);
      apiToken = userDataResponse.access!;
      await setValue(AppSharedPreferenceKeys.apiToken, userDataResponse.access);
      await setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
      await setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
      await setValue(AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());
      await setValue(AppSharedPreferenceKeys.userEmail, request['email'].toString());
      await setValue(AppSharedPreferenceKeys.userModel, jsonEncode(userDataResponse.userModel));
      isLoggedIn(true);
      return true;
    } else {
      await handleFailRegenerateToken();
      return false;
    }
  } catch (e) {
    log('Token regeneration failed: $e');
    await handleFailRegenerateToken();
    return false;
  }
}
// Future<bool> reGenerateToken() async {
//   log('Attempting to regenerate token');
//
//   // Do NOT clear shared preferences before retrieving stored credentials
//   final String email = getStringAsync(AppSharedPreferenceKeys.userEmail);
//   final String password = getStringAsync(AppSharedPreferenceKeys.userPassword);
//
//   if (email.isEmpty || password.isEmpty) {
//     log('Missing credentials, cannot regenerate token');
//     await handleFailRegenerateToken();
//     return false;
//   }
//
//   Map<String, dynamic> request = {
//     ConstantKeys.emailKey: email,
//     ConstantKeys.passwordKey: password,
//   };
//
//   try {
//     // final String? newToken = await AuthServiceApis.login(request: req);
//     UserDataResponseModel userDataResponse = await UserDataResponseModel.fromJson(
//         await buildHttpResponse(
//           endPoint: APIEndPoints.login,
//           request: request,
//           method: MethodType.post,
//           allowTokenRefresh: false,
//         ));
//     if (userDataResponse != null) {
//       loggedInUser(userDataResponse);
//       apiToken = userDataResponse.access!;
//       await setValue(AppSharedPreferenceKeys.apiToken, userDataResponse.access);
//       await setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
//       await setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
//       setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
//       setValue(AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());
//       setValue(AppSharedPreferenceKeys.apiToken, loggedInUser.value.access);
//       setValue(AppSharedPreferenceKeys.userEmail, request['email'].toString()); //userDataResponse.userModel?.email
//       setValue(AppSharedPreferenceKeys.userModel, jsonEncode(userDataResponse.userModel)); //userDataResponse.userModel?.email
//       setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
//       isLoggedIn(true);
//       return true;
//     } else {
//       await handleFailRegenerateToken();
//       return false;
//     }
//   } catch (e) {
//     log('Token regeneration failed: $e');
//     await handleFailRegenerateToken();
//     return false;
//   }
// }


Future handleResponse(Response response, {HttpResponseType httpResponseType = HttpResponseType.JSON}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode == 403) {
    throw 'Page not found';
  } else if (response.statusCode == 429) {
    throw 'Too many requests';
  } else if (response.statusCode == 500) {
    var body = jsonDecode(response.body);
    if (body is Map && body.containsKey('status') && body['status'] is bool && !body['status']) {
      throw parseHtmlString(body['message'] ?? 'Internal server error');
    } else {
      throw 'Internal server error';
    }
  } else if (response.statusCode == 502) {
    throw 'Bad gateway';
  } else if (response.statusCode == 503) {
    throw 'Service unavailable';
  } else if (response.statusCode == 504) {
    throw 'Gateway timeout';
  } else {
    if (response.statusCode.isSuccessful()) {
      var body = jsonDecode(response.body);
      if (body is Map && body.containsKey('status') && body['status'] is bool && !body['status']) {
        throw parseHtmlString(body['message'] ?? errorSomethingWentWrong);
      } else {
        return body;
      }
    } else {
      Map body = jsonDecode(response.body.trim());
      Map<String, dynamic> errorData = {
        'status_code': response.statusCode,
        'status': false,
        "response": body,
        "message": body['message'] ?? body['error'] ?? errorSomethingWentWrong,
      };

      // Handle validation errors if present
      if (body.containsKey('errors') && body['errors'] is Map) {
        List<String> errorMessages = [];
        body['errors'].forEach((key, value) {
          if (value is List) {
            errorMessages.addAll(value.map((e) => e.toString()));
          }
        });
        if (errorMessages.isNotEmpty) {
          errorData["message"] = errorMessages.join("\n");
        }
      }
      throw errorData["message"];
    }
  }
}

//region CommonFunctions
Future<Map<String, String>> getMultipartFields({required Map<String, dynamic> val}) async {
  Map<String, String> data = {};

  val.forEach((key, value) {
    data[key] = '$value';
  });

  return data;
}


String getEndPoint({required String endPoint, int? perPages, int? page, List<String>? params}) {
  List<String> queryParams = [];

  // Add perPage and page only if they exist

  // Append params if they exist

  if (params != null && params.isNotEmpty) {
    queryParams.addAll(params);
  }
  if (perPages != null) queryParams.add("per_page=${perPages}");
  if (page != null) queryParams.add("page=$page");

  return "$endPoint${queryParams.isNotEmpty ? '?${queryParams.join('&')}' : ''}";
}

//endregion

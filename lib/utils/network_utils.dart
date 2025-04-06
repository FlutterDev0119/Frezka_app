// import 'dart:convert';
// import 'dart:io';
//
// import 'package:get/get.dart' as get_state;
// import 'package:http/http.dart';
// import 'package:kivilabs_collector_app/screens/auth/social_login_service.dart';
// import 'package:nb_utils/nb_utils.dart';
//
// import '../configs.dart';
// import '../screens/auth/auth_api_service.dart';
// import '../screens/auth/models/user_model.dart';
// import '../screens/walkthrough/welcome_screen.dart';
// import '../utils/common/common.dart';
// import '../utils/common/common_base.dart';
// import '../utils/constants/constants.dart';
// import '../utils/constants/shared_prefences.dart';
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
//     final headerToken = loggedInUser.value.apiToken.isNotEmpty
//         ? loggedInUser.value.apiToken
//         : getStringAsync(AppSharedPreferenceKeys.apiToken).isNotEmpty
//             ? getStringAsync(AppSharedPreferenceKeys.apiToken)
//             : '';
//     if (headerToken.isNotEmpty) header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${headerToken}');
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
//     if (isLoggedIn.value && response.statusCode == 401) {
//       bool tokenRegenerated = await reGenerateToken();
//
//       if (tokenRegenerated) {
//         return await handleResponse(
//           await buildHttpResponse(
//             endPoint: endPoint,
//             method: method,
//             request: request,
//             header: header,
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
// Future<bool> reGenerateToken() async {
//   bool result = false;
//   Map<String, dynamic>? request;
//
//   if (getBoolAsync(AppSharedPreferenceKeys.isSocialLogin)) {
//     if (loggedInUser.value.loginType == LoginType.otp.name) {
//       request = {
//         ConstantKeys.userNameKey: loggedInUser.value.userName,
//         ConstantKeys.passwordKey: loggedInUser.value.mobileNumber,
//         ConstantKeys.mobileKey: loggedInUser.value.mobileNumber,
//         ConstantKeys.userTypeKey: UserType.collector.name,
//         ConstantKeys.loginTypeKey: LoginType.otp.name,
//         ConstantKeys.firstNameKey: loggedInUser.value.userFirstName,
//         ConstantKeys.lastNameKey: loggedInUser.value.userLastName,
//       };
//     } else if (loggedInUser.value.loginType == LoginType.google.name || loggedInUser.value.loginType == LoginType.apple.name) {
//       request = {
//         ConstantKeys.profileImageKey: loggedInUser.value.profileImage,
//         ConstantKeys.emailKey: loggedInUser.value.userEmail,
//         ConstantKeys.passwordKey: loggedInUser.value.userEmail,
//         ConstantKeys.userTypeKey: UserType.collector.name,
//         ConstantKeys.loginTypeKey: loggedInUser.value.loginType,
//         ConstantKeys.firstNameKey: loggedInUser.value.userFirstName,
//         ConstantKeys.lastNameKey: loggedInUser.value.userLastName,
//         ConstantKeys.mobileNumberKey: loggedInUser.value.mobileNumber,
//       };
//     }
//   } else if (getStringAsync(AppSharedPreferenceKeys.userEmail).isNotEmpty && getStringAsync(AppSharedPreferenceKeys.userPassword).isNotEmpty) {
//     request = {
//       ConstantKeys.emailKey: getStringAsync(AppSharedPreferenceKeys.userEmail),
//       ConstantKeys.passwordKey: getStringAsync(AppSharedPreferenceKeys.userPassword),
//       ConstantKeys.userTypeKey: UserType.collector.name,
//     };
//   } else {
//     result = false;
//   }
//   if (request != null) {
//     await AuthAPIService.login(request: request, isSocialLogin: getBoolAsync(AppSharedPreferenceKeys.isSocialLogin)).then(
//       (value) {
//         result = true;
//       },
//     );
//   } else {
//     await handleFailRegenerateToken();
//   }
//
//   return result;
// }
//
// Future<void> handleFailRegenerateToken() async {
//   await SocialLoginService.deleteCurrentFirebaseUser();
//   isLoggedIn(false);
//   loggedInUser(UserModel());
//
//   setValue(AppSharedPreferenceKeys.isUserLoggedIn, false);
//   setValue(AppSharedPreferenceKeys.currentUserData, loggedInUser.value.toJson());
//   setValue(AppSharedPreferenceKeys.userEmail, '');
//   setValue(AppSharedPreferenceKeys.userPassword, '');
//   setValue(AppSharedPreferenceKeys.apiToken, '');
//   setValue(AppSharedPreferenceKeys.cachedDashboardData, '');
//
//   get_state.Get.offAll(() => WelcomeScreen());
// }
//
// Future handleResponse(Response response, {HttpResponseType httpResponseType = HttpResponseType.JSON}) async {
//   if (!await isNetworkAvailable()) {
//     throw errorInternetNotAvailable;
//   }
//   if (response.statusCode == 403) {
//     throw '${locale.value.forbidden}';
//   } else if (response.statusCode == 429) {
//     throw '${locale.value.tooManyRequests}';
//   } else if (response.statusCode == 500) {
//     var body = jsonDecode(response.body);
//     if (body is Map && body.containsKey('status') && body['status'] is bool && !body['status']) {
//       throw parseHtmlString(body['message'] ?? '${locale.value.internalServerError}');
//     } else {
//       throw '${locale.value.internalServerError}';
//     }
//   } else if (response.statusCode == 502) {
//     throw '${locale.value.badGateway}';
//   } else if (response.statusCode == 503) {
//     throw '${locale.value.serviceUnavailable}';
//   } else if (response.statusCode == 504) {
//     throw '${locale.value.gateWayTimeout}';
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
// Map<String, String> buildHeaderForFlutterWave(String flutterWaveSecretKey) {
//   Map<String, String> header = defaultHeaders();
//
//   header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $flutterWaveSecretKey");
//
//   return header;
// }
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
//
//
//
//
//
//
//
//
//
//
//
// Future<DocumentTypeListResponse> updateCollectorDocument(
//     {required Map<String, dynamic> request, List<File>? imageFile}) async {
//   DocumentTypeListResponse baseResponse = await DocumentTypeListResponse.fromJson(
//     await buildMultiPartResponse(
//       endPoint: getEndPoint(endPoint: VerifyDocumentEndPoints.documentSave),
//       request: request,
//       files: imageFile,
//       fileKey: "collector_document",
//     ),
//   );
//
//   return baseResponse;
// }
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
//               (element, index) async {
//             print('${fileKey}_${index} : ${element.path}');
//             multiPartRequest.files.add(await MultipartFile.fromPath('${fileKey}_${index}', element.path));
//           },
//         );
//       } else if (files.length == 1) {
//         files.forEachIndexed(
//               (element, index) async {
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
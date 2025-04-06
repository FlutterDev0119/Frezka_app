// // ignore_for_file: depend_on_referenced_packages
// import 'dart:convert';
// import 'dart:developer' as dev;
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'api_end_point.dart';
// import 'config.dart';
//
// Map<String, String> buildHeaderTokens({
//   Map? extraKeys,
//   String? endPoint,
// }) {
//   /// Initialize & Handle if key is not present
//   if (extraKeys == null) {
//     extraKeys = {};
//     extraKeys.putIfAbsent('isFlutterWave', () => false);
//     extraKeys.putIfAbsent('isAirtelMoney', () => false);
//   }
//   Map<String, String> header = {
//     HttpHeaders.cacheControlHeader: 'no-cache',
//     'Access-Control-Allow-Headers': '*',
//     'Access-Control-Allow-Origin': '*',
//     'Accept': "application/json",
//   };
//
//   // if (endPoint == APIEndPoints.register) {
//   //   header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json');
//   // }
//   header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
//
//
//     // if (isLoggedIn.value) {
//     if (true) {
//     header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
//     header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${extraKeys!['access_token']}');
//     header.putIfAbsent('X-Country', () => '${extraKeys!['X-Country']}');
//     header.putIfAbsent('X-Currency', () => '${extraKeys!['X-Currency']}');
//   } else {
//       // final isApiToken = getValueFromLocal(SharedPreferenceConst.API_TOKEN);
//     // header.putIfAbsent(HttpHeaders.authorizationHeader, () =>'Bearer $isApiToken');
//   }
//
//   // log(jsonEncode(header));
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
// Future<Response> buildHttpResponse(
//   String endPoint, {
//   HttpMethodType method = HttpMethodType.GET,
//   Map? request,
//   Map? extraKeys,
//   Map<String, String>? header,
// }) async {
//   var headers = header ?? buildHeaderTokens(extraKeys: extraKeys, endPoint: endPoint);
//   Uri url = buildBaseUrl(endPoint);
//
//   Response response;
//   log('URL (${method.name}): $url');
//
//   try {
//     if (method == HttpMethodType.POST) {
//       log('Request: ${jsonEncode(request)}');
//       response = await http.post(url, body: jsonEncode(request), headers: headers);
//     } else if (method == HttpMethodType.DELETE) {
//       response = await delete(url, headers: headers);
//     } else if (method == HttpMethodType.PUT) {
//       response = await put(url, body: jsonEncode(request), headers: headers);
//     } else {
//       response = await get(url, headers: headers);
//     }
//     apiPrint(
//       url: url.toString(),
//       endPoint: endPoint,
//       headers: jsonEncode(headers),
//       request: jsonEncode(request),
//       statusCode: response.statusCode,
//       responseBody: response.body.trim(),
//       methodtype: method.name,
//     );
//     // log('Response (${method.name}) ${response.statusCode}: ${response.body.trim().trim()}');
// //isLoggedIn.value &&
//     if (response.statusCode == 401 && !endPoint.startsWith('http')) {
//       return await reGenerateToken().then((value) async {
//         return await buildHttpResponse(endPoint, method: method, request: request, extraKeys: extraKeys);
//       }).catchError((e) {
//         throw errorSomethingWentWrong;
//       });
//     } else {
//       return response;
//     }
//   } on Exception catch (e) {
//     log(e);
//     if (!await isNetworkAvailable()) {
//       throw errorInternetNotAvailable;
//     } else {
//       throw errorSomethingWentWrong;
//     }
//   }
// }
//
// Future<void> reGenerateToken() async {
//   log('Regenerating Token');
// //   final userPASSWORD = getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
// //   Map req;
// //     req = {
// //       UserKeys.email: loginUserData.value.email,
// //     };
// //   // if (loginUserData.value.loginType.isNotEmpty) {
// //   //   log('LOGINUSERDATA.VALUE.ISSOCIALLOGIN: ${loginUserData.value.loginType}');
// //   //   req[UserKeys.loginType] = loginUserData.value.loginType;
// //   // }
// //   req[UserKeys.password] = userPASSWORD;
// //   return await AuthServiceApis.loginUser(request: req, ).then((value) async {
// //     loginUserData.value.apiToken = value.apiToken;
// //   }).catchError((e) {
// //     AuthServiceApis.clearData();
// //     gets.Get.toNamed(Routes.LOGIN);
// //     throw e;
// //   });
// }
//
// Future handleResponse(Response response, {HttpResponseType httpResponseType = HttpResponseType.JSON, bool? avoidTokenError, bool? isFlutterWave}) async {
//   if (!await isNetworkAvailable()) {
//     throw errorInternetNotAvailable;
//   }
//
//   if (response.statusCode.isSuccessful()) {
//     if (response.body.trim().isJson()) {
//       Map body = jsonDecode(response.body.trim());
//
//       if (body.containsKey('status')) {
//         if (isFlutterWave.validate()) {
//           if (body['status'] == 'success') {
//             return body;
//           } else {
//             throw body['message'] ?? errorSomethingWentWrong;
//           }
//         } else {
//           if (body['status']) {
//             return body;
//           } else {
//             throw body['message'] ?? errorSomethingWentWrong;
//           }
//         }
//       } else {
//         return body;
//       }
//     } else {
//       throw errorSomethingWentWrong;
//     }
//   } else if (response.statusCode == 400) {
//     throw "400: Bad Request";
//   } else if (response.statusCode == 403) {
//     throw "403: Forbidden";
//   } else if (response.statusCode == 404) {
//     throw "404: Page Not Found";
//   } else if (response.statusCode == 429) {
//     throw "429: Too Many Requests";
//   } else if (response.statusCode == 500) {
//     throw "500: Internal Server Error";
//   } else if (response.statusCode == 502) {
//     throw "502: Bad Gateway";
//   } else if (response.statusCode == 503) {
//     throw "503: Service Unavailable";
//   } else if (response.statusCode == 504) {
//     throw "504: Gateway Timeout";
//   } else {
//     Map body = jsonDecode(response.body.trim());
//     if (body.containsKey('status') && body['status']) {
//       return body;
//     } else {
//       throw body['message'] ?? body['error'] ?? errorSomethingWentWrong;
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
// Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
//   String url = baseUrl ?? buildBaseUrl(endPoint).toString();
//   // log(url);
//   return MultipartRequest('POST', Uri.parse(url));
// }
//
// Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
//   http.Response response = await http.Response.fromStream(await multiPartRequest.send());
//   apiPrint(
//     url: multiPartRequest.url.toString(),
//     headers: jsonEncode(multiPartRequest.headers),
//     multipartRequest: {
//       "MultiPart Request fields": multiPartRequest.fields,
//       "MultiPart files": multiPartRequest.files
//           .map(
//             (e) => {
//               e.field: "${e.filename}",
//             },
//           )
//           .toList(),
//     },
//     statusCode: response.statusCode,
//     responseBody: response.body.trim(),
//     methodtype: "MultiPart",
//   );
//   // log("Result: ${response.statusCode} - ${multiPartRequest.fields}");
//   // log(response.body.trim());
//   if (response.statusCode.isSuccessful()) {
//     onSuccess?.call(response.body.trim());
//   } else if (response.statusCode == 401) {//isLoggedIn.value &&
//     await reGenerateToken().then((value) async {
//       await sendMultiPartRequest(multiPartRequest);
//     }).catchError((e) {
//       throw errorSomethingWentWrong;
//     });
//   } else {
//     onError?.call(errorSomethingWentWrong);
//   }
// }
//
// Future<List<MultipartFile>> getMultipartImages2({required List<XFile> files, required String name}) async {
//   List<MultipartFile> multiPartRequest = [];
//
//   await Future.forEach<XFile>(files, (element) async {
//     int i = files.indexOf(element);
//
//     multiPartRequest.add(await MultipartFile.fromPath('$name[${i.toString()}]', element.path.validate()));
//     log('MultipartFile: $name[${i.toString()}]');
//   });
//
//   return multiPartRequest;
// }
//
// void apiPrint({
//   String url = "",
//   String endPoint = "",
//   String headers = "",
//   String request = "",
//   int statusCode = 0,
//   String responseBody = "",
//   String methodtype = "",
//   bool fullLog = false,
//   Map? multipartRequest,
// }) {
//   if (fullLog) {
//     dev.log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
//     dev.log("\u001b[93m Url: \u001B[39m $url");
//     dev.log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
//     dev.log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
//     if (request.isNotEmpty) {
//       dev.log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
//     }
//     if (multipartRequest != null) {
//       dev.log("\u001b[95m Multipart Request: \u001B[39m");
//       multipartRequest.forEach((key, value) {
//         dev.log("\u001b[96m$key:\u001B[39m $value\n");
//       });
//     }
//     dev.log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
//     dev.log('Response ($methodtype) $statusCode: $responseBody');
//     dev.log("\u001B[0m");
//     dev.log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
//   } else {
//     log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
//     log("\u001b[93m Url: \u001B[39m $url");
//     log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
//     log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
//     if (request.isNotEmpty) {
//       log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
//     }
//     if (multipartRequest != null) {
//       log("\u001b[95m Multipart Request: \u001B[39m");
//       multipartRequest.forEach((key, value) {
//         log("\u001b[96m$key:\u001B[39m $value\n");
//       });
//     }
//     log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
//     log('Response ($methodtype) $statusCode: ${formatJson(responseBody)}');
//     log("\u001B[0m");
//     log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
//   }
// }
//
// String formatJson(String jsonStr) {
//   try {
//     final dynamic parsedJson = jsonDecode(jsonStr);
//     const formatter = JsonEncoder.withIndent('  ');
//     return formatter.convert(parsedJson);
//   } on Exception catch (e) {
//     dev.log("\x1b[31m formatJson error ::-> ${e.toString()} \x1b[0m");
//     return jsonStr;
//   }
// }
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
// Map<String, String> buildHeaderForFlutterWave(String flutterWaveSecretKey) {
//   Map<String, String> header = defaultHeaders();
//
//   header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $flutterWaveSecretKey");
//
//   return header;
// }
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart' as get_state;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/common/common.dart';
import '../utils/common/common_base.dart';
import '../utils/constants.dart';
import '../utils/shared_prefences.dart';
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
      // bool tokenRegenerated = await reGenerateToken();
      //
      // if (tokenRegenerated) {
      //   return await handleResponse(
      //     await buildHttpResponse(
      //       endPoint: endPoint,
      //       method: method,
      //       request: request,
      //       header: header,
      //     ),
      //   );
      // }
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

// Future<bool> reGenerateToken() async {
//   bool result = false;
//   Map<String, dynamic>? request;
//
//   if (getBoolAsync(AppSharedPreferenceKeys.isSocialLogin)) {
//       if (loggedInUser.value.loginType == LoginType.otp.name) {
//       request = {
//         // ConstantKeys.userNameKey: loggedInUser.value.userName,
//         // ConstantKeys.passwordKey: loggedInUser.value.mobileNumber,
//         // ConstantKeys.mobileKey: loggedInUser.value.mobileNumber,
//         ConstantKeys.userTypeKey: UserType.collector.name,
//         // ConstantKeys.loginTypeKey: LoginType.otp.name,
//         // ConstantKeys.firstNameKey: loggedInUser.value.userFirstName,
//         // ConstantKeys.lastNameKey: loggedInUser.value.userLastName,
//       };
//     }
//       else if (loggedInUser.value.loginType == LoginType.google.name || loggedInUser.value.loginType == LoginType.apple.name) {
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

Map<String, String> buildHeaderForFlutterWave(String flutterWaveSecretKey) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $flutterWaveSecretKey");

  return header;
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

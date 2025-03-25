// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/constants.dart';
import 'package:get/get.dart' as gets;

import '../utils/local_storage.dart';
import 'api_end_point.dart';
import 'api_sevices.dart';
import 'config.dart';

Map<String, String> buildHeaderTokens({
  Map? extraKeys,
  String? endPoint,
}) {
  /// Initialize & Handle if key is not present
  if (extraKeys == null) {
    extraKeys = {};
    extraKeys.putIfAbsent('isFlutterWave', () => false);
    extraKeys.putIfAbsent('isAirtelMoney', () => false);
  }
  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
    'Accept': "application/json",
  };

  if (endPoint == APIEndPoints.register) {
    header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json');
  }
  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');


    // if (isLoggedIn.value) {
    if (true) {
    header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${extraKeys!['access_token']}');
    header.putIfAbsent('X-Country', () => '${extraKeys!['X-Country']}');
    header.putIfAbsent('X-Currency', () => '${extraKeys!['X-Currency']}');
  } else {
      // final isApiToken = getValueFromLocal(SharedPreferenceConst.API_TOKEN);
    // header.putIfAbsent(HttpHeaders.authorizationHeader, () =>'Bearer $isApiToken');
  }

  // log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  if (!endPoint.startsWith('http')) {
    return Uri.parse('$BASE_URL$endPoint');
  } else {
    return Uri.parse(endPoint);
  }
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  Map? extraKeys,
  Map<String, String>? header,
}) async {
  var headers = header ?? buildHeaderTokens(extraKeys: extraKeys, endPoint: endPoint);
  Uri url = buildBaseUrl(endPoint);

  Response response;
  log('URL (${method.name}): $url');

  try {
    if (method == HttpMethodType.POST) {
      log('Request: ${jsonEncode(request)}');
      response = await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }
    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body.trim(),
      methodtype: method.name,
    );
    // log('Response (${method.name}) ${response.statusCode}: ${response.body.trim().trim()}');
//isLoggedIn.value &&
    if (response.statusCode == 401 && !endPoint.startsWith('http')) {
      return await reGenerateToken().then((value) async {
        return await buildHttpResponse(endPoint, method: method, request: request, extraKeys: extraKeys);
      }).catchError((e) {
        throw errorSomethingWentWrong;
      });
    } else {
      return response;
    }
  } on Exception catch (e) {
    log(e);
    if (!await isNetworkAvailable()) {
      throw errorInternetNotAvailable;
    } else {
      throw errorSomethingWentWrong;
    }
  }
}

Future<void> reGenerateToken() async {
  log('Regenerating Token');
//   final userPASSWORD = getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
//   Map req;
//     req = {
//       UserKeys.email: loginUserData.value.email,
//     };
//   // if (loginUserData.value.loginType.isNotEmpty) {
//   //   log('LOGINUSERDATA.VALUE.ISSOCIALLOGIN: ${loginUserData.value.loginType}');
//   //   req[UserKeys.loginType] = loginUserData.value.loginType;
//   // }
//   req[UserKeys.password] = userPASSWORD;
//   return await AuthServiceApis.loginUser(request: req, ).then((value) async {
//     loginUserData.value.apiToken = value.apiToken;
//   }).catchError((e) {
//     AuthServiceApis.clearData();
//     gets.Get.toNamed(Routes.LOGIN);
//     throw e;
//   });
}

Future handleResponse(Response response, {HttpResponseType httpResponseType = HttpResponseType.JSON, bool? avoidTokenError, bool? isFlutterWave}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (response.statusCode.isSuccessful()) {
    if (response.body.trim().isJson()) {
      Map body = jsonDecode(response.body.trim());

      if (body.containsKey('status')) {
        if (isFlutterWave.validate()) {
          if (body['status'] == 'success') {
            return body;
          } else {
            throw body['message'] ?? errorSomethingWentWrong;
          }
        } else {
          if (body['status']) {
            return body;
          } else {
            throw body['message'] ?? errorSomethingWentWrong;
          }
        }
      } else {
        return body;
      }
    } else {
      throw errorSomethingWentWrong;
    }
  } else if (response.statusCode == 400) {
    throw "400: Bad Request";
  } else if (response.statusCode == 403) {
    throw "403: Forbidden";
  } else if (response.statusCode == 404) {
    throw "404: Page Not Found";
  } else if (response.statusCode == 429) {
    throw "429: Too Many Requests";
  } else if (response.statusCode == 500) {
    throw "500: Internal Server Error";
  } else if (response.statusCode == 502) {
    throw "502: Bad Gateway";
  } else if (response.statusCode == 503) {
    throw "503: Service Unavailable";
  } else if (response.statusCode == 504) {
    throw "504: Gateway Timeout";
  } else {
    Map body = jsonDecode(response.body.trim());
    if (body.containsKey('status') && body['status']) {
      return body;
    } else {
      throw body['message'] ?? body['error'] ?? errorSomethingWentWrong;
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

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  String url = baseUrl ?? buildBaseUrl(endPoint).toString();
  // log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  apiPrint(
    url: multiPartRequest.url.toString(),
    headers: jsonEncode(multiPartRequest.headers),
    multipartRequest: {
      "MultiPart Request fields": multiPartRequest.fields,
      "MultiPart files": multiPartRequest.files
          .map(
            (e) => {
              e.field: "${e.filename}",
            },
          )
          .toList(),
    },
    statusCode: response.statusCode,
    responseBody: response.body.trim(),
    methodtype: "MultiPart",
  );
  // log("Result: ${response.statusCode} - ${multiPartRequest.fields}");
  // log(response.body.trim());
  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body.trim());
  } else if (response.statusCode == 401) {//isLoggedIn.value &&
    await reGenerateToken().then((value) async {
      await sendMultiPartRequest(multiPartRequest);
    }).catchError((e) {
      throw errorSomethingWentWrong;
    });
  } else {
    onError?.call(errorSomethingWentWrong);
  }
}

Future<List<MultipartFile>> getMultipartImages2({required List<XFile> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<XFile>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('$name[${i.toString()}]', element.path.validate()));
    log('MultipartFile: $name[${i.toString()}]');
  });

  return multiPartRequest;
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool fullLog = false,
  Map? multipartRequest,
}) {
  if (fullLog) {
    dev.log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    dev.log("\u001b[93m Url: \u001B[39m $url");
    dev.log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    dev.log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (request.isNotEmpty) {
      dev.log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    if (multipartRequest != null) {
      dev.log("\u001b[95m Multipart Request: \u001B[39m");
      multipartRequest.forEach((key, value) {
        dev.log("\u001b[96m$key:\u001B[39m $value\n");
      });
    }
    dev.log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    dev.log('Response ($methodtype) $statusCode: $responseBody');
    dev.log("\u001B[0m");
    dev.log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  } else {
    log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
    log("\u001b[93m Url: \u001B[39m $url");
    log("\u001b[93m endPoint: \u001B[39m \u001B[1m$endPoint\u001B[22m");
    log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
    if (request.isNotEmpty) {
      log('\u001b[93m Request: \u001B[39m \u001b[95m$request\u001B[39m');
    }
    if (multipartRequest != null) {
      log("\u001b[95m Multipart Request: \u001B[39m");
      multipartRequest.forEach((key, value) {
        log("\u001b[96m$key:\u001B[39m $value\n");
      });
    }
    log(statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m");
    log('Response ($methodtype) $statusCode: ${formatJson(responseBody)}');
    log("\u001B[0m");
    log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
  }
}

String formatJson(String jsonStr) {
  try {
    final dynamic parsedJson = jsonDecode(jsonStr);
    const formatter = JsonEncoder.withIndent('  ');
    return formatter.convert(parsedJson);
  } on Exception catch (e) {
    dev.log("\x1b[31m formatJson error ::-> ${e.toString()} \x1b[0m");
    return jsonStr;
  }
}

Map<String, String> defaultHeaders() {
  Map<String, String> header = {};

  header.putIfAbsent(HttpHeaders.cacheControlHeader, () => 'no-cache');
  header.putIfAbsent('Access-Control-Allow-Headers', () => '*');
  header.putIfAbsent('Access-Control-Allow-Origin', () => '*');

  return header;
}

Map<String, String> buildHeaderForFlutterWave(String flutterWaveSecretKey) {
  Map<String, String> header = defaultHeaders();

  header.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $flutterWaveSecretKey");

  return header;
}

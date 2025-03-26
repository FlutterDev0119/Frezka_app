// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import '../../../network/api_end_point.dart';
// import '../../../network/api_sevices.dart';
// import '../../../network/config.dart';
// import '../../../routes/app_pages.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:http/http.dart' as http;
// import '../../../utils/constants.dart';
// import '../../../utils/local_storage.dart';
//
// class LoginController extends GetxController {
//   RxBool isNavigateToDashboard = false.obs;
//   final GlobalKey<FormState> signInformKey = GlobalKey();
//
//   RxBool isRememberMe = true.obs;
//   RxBool isLoading = false.obs;
//   RxString userName = "".obs;
//   RxBool isSendOTP = false.obs;
//
//   TextEditingController emailCont = TextEditingController();
//   TextEditingController passwordCont = TextEditingController();
//   TextEditingController otpCont = TextEditingController();
//
//   FocusNode emailFocus = FocusNode();
//   FocusNode passwordFocus = FocusNode();
//   FocusNode otpFocus = FocusNode();
//
//   List selectedLoginRole = ["admin", "user"];
//
//   @override
//   void onInit() {
//     super.onInit();
//     // checkSession();
//   }
//
//   Future<void> checkSession() async {
//     final token = (await getValueFromLocal(SharedPreferenceConst.API_TOKEN));
//     if (token != null) {
//           Get.offAllNamed(Routes.HOME);
//         } else {
//           await removeValueFromLocal(SharedPreferenceConst.API_TOKEN);
//           Get.offAllNamed(Routes.LOGIN);
//         }
//       }
//
//
//
//   void toggleSwitch() {
//     isRememberMe.value = !isRememberMe.value;
//   }
//
//   Future<void> saveForm() async {
//     isLoading(true);
//     Map<String, dynamic> req = {
//       'email': emailCont.text.trim(),
//       'password': passwordCont.text.trim(),
//     };
//
//     await AuthServiceApis.sendOTP(request: req).then((value) async {
//       isSendOTP(true);
//     }).catchError((e) {
//       isLoading(false);
//       toast(e.toString(), print: true);
//     });
//   }
//   Future<void> otpVerification() async {
//     if (emailCont.text.trim().isEmpty ||
//         passwordCont.text.trim().isEmpty ||
//         otpCont.text.trim().isEmpty) {
//       toast("Please fill in all fields", print: true);
//       return;
//     }
//
//     isLoading(true);
//     Map<String, dynamic> req = {
//       'email': emailCont.text.trim(),
//       'password': passwordCont.text.trim(),
//       'otp': otpCont.text.trim(),
//     };
//
//     try {
//       var userData = await AuthServiceApis.loginUser(request: req);
//
//       if (userData.apiToken != null) {
//         // Store the API token locally
//         await setValueToLocal(SharedPreferenceConst.API_TOKEN, "${userData.apiToken}");
//         Get.toNamed(Routes.HOME);
//         clearFormFields();
//         isSendOTP(false);
//       } else {
//         throw "Error: Invalid token received";
//       }
//     } catch (e) {
//       // Check if the error is an API response message
//       if (e is String) {
//         // Directly print the error message from the API
//         toast(e, print: true);
//       } else {
//         // Fallback for any unknown error
//         toast("An unexpected error occurred", print: true);
//       }
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   var googleAccount = Rx<GoogleSignInAccount?>(null);
//
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   Future<void> loginWithGoogle() async {
//     try {
//       googleAccount.value = await _googleSignIn.signIn();
//       if (googleAccount.value != null) {
//         String? displayName = googleAccount.value?.displayName ?? '';
//         List<String> nameParts = displayName.split(' ');
//         String firstName = nameParts.isNotEmpty ? nameParts.first : 'First';
//         String lastName =
//         nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Last';
//
//         Map<String, dynamic> req = {
//           "email": googleAccount.value?.email.toString(),
//           "username": googleAccount.value?.displayName,
//           "first_name": firstName,
//           "last_name": lastName,
//           "login_type": "google",
//           "user_type": "supplier",
//         };
//         GoogleSignInAuthentication googleAuth = await googleAccount.value!.authentication;
//
//         // Access the token
//         String? accessToken = googleAuth.accessToken;
//         String? idToken = googleAuth.idToken;
//
//         // Example usage
//         if (accessToken != null) {
//           Map<String, dynamic> socialreq = {
//             "email": googleAccount.value?.email.toString(),
//
//           };
//           await AuthServiceApis.sendOTP(request: socialreq).then((value) async {
//             isSendOTP(true);
//           }).catchError((e) {
//             isLoading(false);
//             toast(e.toString(), print: true);
//           });
//           print('Access Token: $accessToken');
//         }
//
//         if (idToken != null) {
//           print('ID Token: $idToken');
//         }
//
//         // await AuthServiceApis.googleSocialLogin(request: req)
//         //     .then((value) async {
//         //
//         //   setValueToLocal(SharedPreferenceConst.API_TOKEN, value.data.apiToken);
//         //   // SharedPreferences? prefs = await getSharedPreferences();
//         //   // prefs?.setString(SharedPreferenceConst.API_TOKEN, value.data.apiToken);
//         //   // toast("Create Stitching Jobs");
//         // }).catchError((e) {
//         //   toast(e.toString(), print: true);
//         // });
//         setValueToLocal(SharedPreferenceConst.API_TOKEN, accessToken);
//         Get.snackbar(
//             "Success", "Logged in as ${googleAccount.value!.displayName}");
//         Get.toNamed(Routes.HOME);
//       }
//     } catch (error) {
//       Get.snackbar("Error", "Login failed: $error");
//     }
//   }
//
//   // Future<void> logout() async {
//   //   removeValueFromLocal(SharedPreferenceConst.API_TOKEN);
//   //   await _googleSignIn.signOut();
//   //   Get.toNamed(Routes.LOGIN);
//   //   Get.snackbar("Logged Out", "Successfully signed out");
//   // }
//   // Future<void> logout() async {
//   //   print("logout------------------");
//   //   try {
//   //     final isApiToken = await getValueFromLocal(SharedPreferenceConst.API_TOKEN);
//   //     print("API Token: $isApiToken");
//   //     // print('$BASE_URL${APIEndPoints.logout}');
//   //
//   //     // final response = await http.get(
//   //       // Uri.parse('$BASE_URL${APIEndPoints.logout}'),
//   //       // headers: {
//   //       //   'Authorization': 'Bearer $isApiToken',
//   //       // },
//   //     // );
//   //
//   //     // print("response.statusCode: ${response.statusCode}");
//   //     // print("response.body: ${response.body}");
//   //
//   //     // if (response.statusCode == 200) {
//   //     //   final responseData = jsonDecode(response.body);
//   //     //
//   //     //   // Assuming the API returns a "message" field
//   //     //   if (responseData['message'] != null) {
//   //     //     Get.snackbar("Success", responseData['message']);
//   //     //   }
//   //
//   //       // Perform any cleanup, like removing tokens or navigating to login
//   //       await removeValueFromLocal(SharedPreferenceConst.API_TOKEN);
//   //       Get.offAllNamed(Routes.LOGIN); // Navigate to login screen
//   //     } else {
//   //       Get.snackbar("Error", "Failed to logout");
//   //     }
//   //   } catch (e) {
//   //     print(e.toString());
//   //     Get.snackbar("Error", "Something went wrong");
//   //   }
//   // }
//
//   void clearFormFields() {
//     emailCont.clear();
//     passwordCont.clear();
//     otpCont.clear();
//   }
// }
// class ApiError {
//   final String message;
//
//   ApiError({required this.message});
//
//   factory ApiError.fromJson(Map<String, dynamic> json) {
//     return ApiError(
//       message: json['error'] as String,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'error': message,
//     };
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../network/api_sevices.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/local_storage.dart';

class LoginController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool isRememberMe = true.obs;
  RxBool isLoading = false.obs;
  RxBool isSendOTP = false.obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController otpCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode otpFocus = FocusNode();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> saveForm() async {
    isLoading(true);
    Map<String, dynamic> req = {
      'email': emailCont.text.trim(),
      'password': passwordCont.text.trim(),
    };

    await AuthServiceApis.sendOTP(request: req).then((value) async {
      isSendOTP(true);
    }).catchError((e) {
      isLoading(false);
      Get.snackbar("Error", e.toString());
    });
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        String? accessToken = googleAuth.accessToken;
        String? idToken = googleAuth.idToken;

        Map<String, dynamic> req = {
          "email": googleUser.email,
          "username": googleUser.displayName,
          "login_type": "google",
        };

        await setValueToLocal("API_TOKEN", accessToken);

        Get.snackbar("Success", "Logged in as ${googleUser.displayName}");
        Get.offAllNamed(Routes.HOME);
      }
    } catch (error) {
      Get.snackbar("Error", "Login failed: $error");
    }
  }
}

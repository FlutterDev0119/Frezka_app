
import 'dart:math';
import '../../../utils/common/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../network/api_sevices.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';

class LoginController extends BaseController {
  RxBool isPasswordVisible = false.obs;
  RxBool isRememberMe = true.obs;
  // RxBool isLoading = false.obs;
  RxBool isSendOTP = false.obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController otpCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode otpFocus = FocusNode();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> loginUser() async {
    if (isLoading.value) return;
    setLoading(true);

    Map<String, dynamic> request = {
      ConstantKeys.emailKey: "sandesh.singhal@pvanalytica.com",//emailCont.text.trim(),
      ConstantKeys.passwordKey: "Pvana@123"//passwordCont.text.trim(),
    };
    print("request  $request");
    try {
      String? refreshToken = await AuthServiceApis.login(
        request: request,
        isSocialLogin: false,
      );

      if (refreshToken != null) {
        Get.snackbar("Success", "Logged in successfully!");
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar("Error", "Login failed");
      }
    } catch (e) {
      setLoading(false);
      Get.snackbar("Error", "Login failed: ${e.toString()}");
    } finally {
      setLoading(false);
    }
  }


  Future<void> loginWithGoogle() async {
    if (isLoading.value) return;
    setLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        String? accessToken = googleAuth.accessToken;
        String? idToken = googleAuth.idToken;

        Map<String, dynamic> req = {
          "email": googleUser.email,
          "username": googleUser.displayName,
          // "login_type": "google",
        };

        await setValueToLocal("API_TOKEN", accessToken);

        Get.snackbar("Success", "Logged in as ${googleUser.displayName}");
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } catch (error) {
      setLoading(false);
      Get.snackbar("Error", "Login failed: $error");
    }
  }
}

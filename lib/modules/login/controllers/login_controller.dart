
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } catch (error) {
      Get.snackbar("Error", "Login failed: $error");
    }
  }
}

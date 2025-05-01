import 'package:nb_utils/nb_utils.dart';
import '../../../utils/common/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../network/api_sevices.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../../../utils/shared_prefences.dart';

class LoginController extends BaseController {
  RxBool isPasswordVisible = false.obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> loginUser() async {
    if (isLoading.value) return;
    setLoading(true);

    Map<String, dynamic> request = {
      ConstantKeys.emailKey: "sandesh.singhal@pvanalytica.com", //emailCont.text.trim(),//, //
      ConstantKeys.passwordKey: "Pvana@123", //passwordCont.text.trim(),//
    };
    print(request);
    try {
      String? refreshToken = await AuthServiceApis.login(
        request: request,
      );

      if (refreshToken != null) {
        toast("Logged in successfully!");
        Get.offAllNamed(Routes.DASHBOARD);
        await setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
        // await setValue(ConstantKeys.passwordKey, "Pvana@123");
      } else {
        toast("Login failed");
      }
    } catch (e) {
      setLoading(false);
      toast("Login failed: ${e.toString()}");
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
        log("-------------------------------------------");
        log(googleAuth.idToken);
        log(googleAuth.accessToken);
        log("-------------------------------------------");

        Map<String, dynamic> req = {
          "token": accessToken,
        };
        await AuthServiceApis.googleSocialLogin(
          request: req,
        ).then(
          (value) async {
            await setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
            await setValue(AppSharedPreferenceKeys.apiToken, accessToken);
            toast("Logged in as ${googleUser.displayName}");
            Get.offAllNamed(Routes.DASHBOARD);
          },
        );
      }
    } catch (error) {
      setLoading(false);
      toast("Login failed: $error");
    } finally {
      setLoading(false);
    }
  }
}

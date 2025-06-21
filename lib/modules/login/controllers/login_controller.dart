import 'package:nb_utils/nb_utils.dart';
import '../../../utils/common/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../network/api_sevices.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/common/common.dart';
import '../../../utils/constants.dart';
import '../../../utils/shared_prefences.dart';

class LoginController extends BaseController {
  RxBool isPasswordVisible = false.obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Future<void> loginUser() async {
  //   if (isLoading.value) return;
  //   setLoading(true);
  //
  //   Map<String, dynamic> request = {
  //     ConstantKeys.emailKey: "sandesh.singhal@pvanalytica.com",
  //     ConstantKeys.passwordKey: "Pvana@123",
  //   };
  //
  //   try {
  //     String? refreshToken = await AuthServiceApis.login(request: request);
  //
  //     if (refreshToken != null) {
  //       toast("Logged in successfully!");
  //
  //       // Save all preferences and user data BEFORE navigation
  //       await setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
  //       await setValue(AppSharedPreferenceKeys.userEmail, request[ConstantKeys.emailKey]);
  //       await setValue(AppSharedPreferenceKeys.apiToken, refreshToken);
  //       await setValue(AppSharedPreferenceKeys.isUserLoggedIn, true);
  //       isLoggedIn(true);
  //
  //       // Also update your reactive user model if needed
  //       loggedInUser.value.access = refreshToken;
  //
  //       /// 🚀 Only now navigate to Dashboard
  //       Get.offAllNamed(Routes.DASHBOARD);
  //     } else {
  //       toast("Login failed");
  //     }
  //   } catch (e) {
  //     toast("Login failed: ${e.toString()}");
  //   } finally {
  //     setLoading(false);
  //   }
  // }

  Future<void> loginUser() async {
    if (isLoading.value) return;
    setLoading(true);
    await setValue(AppSharedPreferenceKeys.isUserLoggedIn, false);
    await setValue(AppSharedPreferenceKeys.apiToken, '');
    await setValue(AppSharedPreferenceKeys.currentUserData, '');
    await setValue(AppSharedPreferenceKeys.refreshToken, "");
    loggedInUser.value.access ='';

    await clearSharedPref();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Map<String, dynamic> request = {
      ConstantKeys.emailKey: "sandesh.singhal@pvanalytica.com",// emailCont.text.trim(),//"sandesh.singhal@pvanalytica.com",
      ConstantKeys.passwordKey: "Pvana@123",//passwordCont.text.trim(),//"Pvana@123",
    };
    print(request);
    print(request[ConstantKeys.passwordKey]);
    try {
      String? refreshToken = await AuthServiceApis.login(
        request: request,
      );

      if (refreshToken != null) {
        toast("Logged in successfully!");
        Get.offAllNamed(Routes.DASHBOARD);
        await setValue(AppSharedPreferenceKeys.userPassword, request[ConstantKeys.passwordKey]);
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

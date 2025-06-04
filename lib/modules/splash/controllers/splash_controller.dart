//
// import 'dart:convert';
// import 'package:flutter/widgets.dart';
// import 'package:get/engageAI.dart';
// import 'package:nb_utils/nb_utils.dart';
//
// import '../../../utils/common/base_controller.dart';
// import '../../../utils/common/common.dart';
// import '../../../utils/library.dart';
// import '../../../utils/shared_prefences.dart';
//
// class SplashController extends BaseController {
//   @override
//   void onInit() {
//     super.onInit();
//     init();
//   }
//
//   /// Initializes splash logic: fetch cache and navigate.
//   Future<void> init() async {
//     await getCacheData();
//
//   }
//
//   /// Determines where to navigate after splash.
//   void handleNavigation() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (isLoggedIn.value == true) {
//         Get.offAllNamed(Routes.DASHBOARD);
//       } else {
//         Get.offAllNamed(Routes.LOGIN);
//       }
//     });
//   }
//
//   /// Loads cached user data if present.
//   Future<void> getCacheData() async {
//     isLoggedIn(getBoolAsync(AppSharedPreferenceKeys.isUserLoggedIn, defaultValue: false));
//     toast(isLoggedIn.value.toString());
//     final token = getStringAsync(AppSharedPreferenceKeys.apiToken);
//     if (token.isNotEmpty) {
//       apiToken = token;
//     }
//
//     final userDataStr = getStringAsync(AppSharedPreferenceKeys.currentUserData);
//     if (userDataStr.isNotEmpty) {
//       try {
//         final userData = UserDataResponseModel.fromJson(jsonDecode(userDataStr));
//         loggedInUser(userData);
//       } catch (e) {
//         log("Error decoding user data: $e");
//       }
//     }
//      handleNavigation();
//   }
// }
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common/base_controller.dart';
import '../../../utils/common/common.dart';
import '../../../utils/library.dart';
import '../../../utils/shared_prefences.dart';

class SplashController extends BaseController {
  @override
  void onInit() {
    super.onInit();
    init();
  }

  /// Initializes splash logic
  Future<void> init() async {
    await getCacheData();

    // Add a small delay (optional, for splash screen feel)
    // await Future.delayed(const Duration(milliseconds: 500));

    await handleNavigation();
  }

  /// Loads cached data and sets up state
  Future<void> getCacheData() async {
    final loginStatus = getBoolAsync(AppSharedPreferenceKeys.isUserLoggedIn, defaultValue: false);
    isLoggedIn(loginStatus);

    // if (kDebugMode) toast("Logged In: ${isLoggedIn.value}");

    final token = getStringAsync(AppSharedPreferenceKeys.apiToken);
    if (token.isNotEmpty) {
      apiToken = token;
    }

    final userDataStr = getStringAsync(AppSharedPreferenceKeys.currentUserData);
    if (userDataStr.isNotEmpty) {
      try {
        final userData = UserDataResponseModel.fromJson(jsonDecode(userDataStr));
        loggedInUser(userData);
      } catch (e) {
        log("Error decoding user data: $e");
      }
    }
  }

  /// Handles navigation after splash
  Future<void> handleNavigation() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() {
        // if (isLoggedIn.value) {
        //   Get.offAllNamed(Routes.DASHBOARD);
        // } else {
          Get.offAllNamed(Routes.LOGIN);
        // }
      });
    });
  }
}

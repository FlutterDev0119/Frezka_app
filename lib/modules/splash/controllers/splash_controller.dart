// import 'dart:convert';
//
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
//   Future<void> init() async {
//     getCacheData();
//     await Future.delayed(const Duration(seconds: 1));
//     handleNavigation();
//   }
//
//
//   handleNavigation() async {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (isLoggedIn == true) {
//         Get.offAllNamed(Routes.DASHBOARD);
//       } else {
//         Get.offAllNamed(Routes.LOGIN);
//       }
//     });
//   }
//
//   getCacheData() {
//     isLoggedIn(getBoolAsync(AppSharedPreferenceKeys.isUserLoggedIn,
//         defaultValue: false));
//
//     if (getStringAsync(AppSharedPreferenceKeys.apiToken).isNotEmpty) {
//       apiToken = getStringAsync(AppSharedPreferenceKeys.apiToken);
//     }
//
//     if (getStringAsync(AppSharedPreferenceKeys.currentUserData).isNotEmpty) {
//       loggedInUser(UserDataResponseModel.fromJson(
//           jsonDecode(getStringAsync(AppSharedPreferenceKeys.currentUserData))));
//     }
//   }
// }
import 'dart:convert';
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

  /// Initializes splash logic: fetch cache and navigate.
  Future<void> init() async {
    await getCacheData();
    // await Future.delayed(const Duration(seconds: 1));
    handleNavigation();
  }

  /// Determines where to navigate after splash.
  void handleNavigation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLoggedIn.value == true) {
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  /// Loads cached user data if present.
  Future<void> getCacheData() async {
    isLoggedIn(getBoolAsync(AppSharedPreferenceKeys.isUserLoggedIn, defaultValue: false));

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
}

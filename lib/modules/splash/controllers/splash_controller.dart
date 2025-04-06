import 'dart:convert';

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

  Future<void> init() async {
    getCacheData();
    await Future.delayed(const Duration(seconds: 1));
    handleNavigation();
  }


  handleNavigation() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLoggedIn == true) {
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  getCacheData() {
    isLoggedIn(getBoolAsync(AppSharedPreferenceKeys.isUserLoggedIn,
        defaultValue: false));

    if (getStringAsync(AppSharedPreferenceKeys.apiToken).isNotEmpty) {
      apiToken = getStringAsync(AppSharedPreferenceKeys.apiToken);
    }

    if (getStringAsync(AppSharedPreferenceKeys.currentUserData).isNotEmpty) {
      loggedInUser(UserDataResponseModel.fromJson(
          jsonDecode(getStringAsync(AppSharedPreferenceKeys.currentUserData))));
    }
  }
}

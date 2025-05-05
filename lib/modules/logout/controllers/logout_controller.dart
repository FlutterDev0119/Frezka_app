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
import '../../forgot_password/model/forgot_password_model.dart';

class LogoutController extends BaseController {
  // void logout(BuildContext context) {
  // // Add your logout logic here
  // print("User logged out");
  //
  // Navigator.of(context).pop(); // Close dialog or navigate
  // }

  void cancel(BuildContext context) {
  Navigator.of(context).pop();
  }

  static Future<void> logout() async {
    await clearSharedPref();
    isLoggedIn(false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
  }

}

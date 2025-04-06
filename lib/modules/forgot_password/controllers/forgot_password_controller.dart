
import 'dart:math';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../network/api_sevices.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';

class ForgotPasswordController extends BaseController {
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey();
  TextEditingController emailCont = TextEditingController();

  FocusNode emailFocus = FocusNode();

  Future<void> forgotPasswordApi() async {
    if (isLoading.value) return;
    setLoading(true);
    Map<String, dynamic> request = {ConstantKeys.emailKey: emailCont.text};

    await AuthServiceApis.forgotPassword(request: request).whenComplete(() => setLoading(false)).then((response) {
      toast(response.message);
      Get.back(result: true);
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../network/api_sevices.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;

  final GlobalKey<FormState> signUpformKey = GlobalKey();

  RxBool agree = false.obs;
  RxBool isAcceptedTc = false.obs;
  TextEditingController emailCont = TextEditingController();
  TextEditingController fisrtNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController userTypeCont = TextEditingController();
  TextEditingController clinicCenterCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode fisrtNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode userTypeFocus = FocusNode();
  FocusNode clinicCenterFocus = FocusNode();
  List<String> userTypes = ["Admin", "User"];

  // Reactive variable to store selected item
  var selectedUserType = "Admin".obs;

  // Function to update selected value
  void setSelectedUserType(String value) {
    selectedUserType.value = value;
  }
  Future saveForm() async {

    isLoading(true);
    Map<String, dynamic> req = {
      "first_name": fisrtNameCont.text.validate(),
      "last_name": lastNameCont.text.validate(),
      "username": fisrtNameCont.text.toLowerCase(),
      "email": emailCont.text.validate(),
      "password": passwordCont.text.validate(),
      "confirm_password": passwordCont.text.validate(),
      "user_type": selectedUserType.value.toString(),
    };
    print("req-----------$req");
    await AuthServiceApis.createUser(request: req).then((value) async {
      clearFormFields();
      // Get.offNamed(Routes.LOGIN);
      toast("Registration successful.");
    }).catchError((e) {
      isLoading(false);
      // Get.offNamed(Routes.LOGIN);
      // toast(e.toString(), print: true);
    });
  }
  void clearFormFields() {
    emailCont.clear();
    fisrtNameCont.clear();
    lastNameCont.clear();
    passwordCont.clear();
    userTypeCont.clear();
    clinicCenterCont.clear();
  }

}

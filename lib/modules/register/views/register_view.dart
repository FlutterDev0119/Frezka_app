import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../colors.dart';
import '../../../common_base.dart';
import '../controllers/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController signUpController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBF8FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.012),
            Image.asset(
              "assets/images/signup.jpg",
              height: 210,
            ),
            Text(
              "Create Your Account",
              style: primaryTextStyle(size: 24),
            ),
            8.height,
            Text(
              "Register Your Account For Better Experience",
              style: secondaryTextStyle(size: 14),
            ),
            SizedBox(height: Get.height * 0.02),
            Form(
              key: signUpController.signUpformKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: signUpController.fisrtNameCont,
                    focus: signUpController.fisrtNameFocus,
                    nextFocus: signUpController.lastNameFocus,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(
                      context,
                      fillColor: context.cardColor,
                      filled: true,
                      hintText: "First Name",
                    ),
                  ).paddingTop(16),
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: signUpController.lastNameCont,
                    focus: signUpController.lastNameFocus,
                    nextFocus: signUpController.emailFocus,
                    textFieldType: TextFieldType.NAME,
                    decoration: inputDecoration(
                      context,
                      fillColor: context.cardColor,
                      filled: true,
                      hintText: "Last Name",
                    ),
                  ).paddingTop(16),
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: signUpController.emailCont,
                    focus: signUpController.emailFocus,
                    nextFocus: signUpController.passwordFocus,
                    textFieldType: TextFieldType.EMAIL_ENHANCED,
                    decoration: inputDecoration(
                      context,
                      fillColor: context.cardColor,
                      filled: true,
                      hintText: "Email",
                    ),
                  ).paddingTop(16),
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12),
                    controller: signUpController.passwordCont,
                    focus: signUpController.passwordFocus,
                    textFieldType: TextFieldType.PASSWORD,
                    decoration: inputDecoration(
                      context,
                      fillColor: context.cardColor,
                      filled: true,
                      hintText: "password",
                    ),
                  ).paddingTop(16),
                  Obx(() {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                        // Border similar to other fields
                        color: context
                            .cardColor, // Background color to match other fields
                      ),
                      child: DropdownButtonFormField<String>(
                        value: signUpController.selectedUserType.value,
                        items: signUpController.userTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          signUpController.setSelectedUserType(newValue!);
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: InputBorder.none,
                          hintText: 'Select User Type',
                        ),
                        style: primaryTextStyle(
                            size: 12), // Similar text style as other fields
                      ),
                    ).paddingTop(16);
                  }),
                  AppButton(
                    width: Get.width,
                    text: "Sign Up",
                    color: appColorSecondary,
                    textStyle: appButtonTextStyleWhite,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: radius(defaultAppButtonRadius / 2)),
                    onTap: () async {
                      if (signUpController.signUpformKey.currentState!
                          .validate()) {
                        signUpController.saveForm();
                      }
                    },
                  ).paddingTop(8),
                ],
              ),
            ).paddingSymmetric(horizontal: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("alreadyHaveAnAccount", style: secondaryTextStyle()),
                4.width,
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "signIn",
                    style: primaryTextStyle(
                      size: 12,
                      color: appColorSecondary,
                      decoration: TextDecoration.underline,
                      decorationColor: appColorSecondary,
                    ),
                  ).paddingSymmetric(horizontal: 8),
                ),
              ],
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}

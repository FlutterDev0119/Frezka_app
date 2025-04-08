import 'package:apps/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/common/colors.dart';
import '../../../utils/common/common.dart';
import '../../../utils/common/common_base.dart';
import '../../../utils/component/app_text_field_with_label_component.dart';
import '../../../utils/component/app_widgets.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  ForgotPasswordScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: controller.isLoading,
      hasLeadingWidget: true,
      appBarBackgroundColor: AppColors.primary,
      appBarTitleText: "Forgot Password",
      appBarTitleTextStyle: TextStyle(
        fontSize: 20,
        color: AppColors.whiteColor,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(Assets.imagesForgot,
                  height: Get.height *.3,
                ),
              ),
              8.height,
              Text(
                "Please enter the email address you'd like your password reset information sent to",
                style: secondaryTextStyle(size: 16),
              ),
              24.height,
              Form(
                key: controller.forgetPasswordFormKey,
                child: AppTextField(
                  textFieldType: TextFieldType.EMAIL,
                  controller: controller.emailCont,
                  isValidationRequired: true,
                  errorThisFieldRequired: "Email Required",
                  errorInvalidEmail: "Invalid email",
                  decoration: appInputDecoration(
                    context: context,
                    prefixIcon: AppIconWidget(icon: Icons.email_outlined),
                    hintText: "Enter email address",
                  ),
                ),
              ),
              24.height,
              AppButtonWidget(
                buttonColor: AppColors.primary,
                text: "Request reset link",
                width: double.infinity,
                onTap: () {
                  hideKeyboard(context);
                  // controller.handleForgetPassword();
                },
              ),
              // 24.height,
              // AppButtonWidget(
              //   buttonColor: AppColors.whiteColor,
              //   textColor: AppColors.primary,
              //   text: "Back to Login",
              //   width: double.infinity,
              //   onTap: () => Get.back(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

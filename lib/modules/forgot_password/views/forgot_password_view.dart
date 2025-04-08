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

// class ForgotPasswordScreen extends StatelessWidget {
//   final ForgotPasswordController controller = Get.put(ForgotPasswordController());
//
//   ForgotPasswordScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       isLoading: controller.isLoading,
//       hasLeadingWidget: true,
//         appBarBackgroundColor: AppColors.primary,
//         appBarTitleText: "Forgot Password",
//
//         appBarTitleTextStyle: TextStyle(
//         fontSize: 20,
//         color: AppColors.whiteColor,),
//       body: AnimatedScrollView(
//         listAnimationType: commonListAnimationType,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           (Get.height * 0.04).toInt().height,
//           // Text("Forgot Password?", style: boldTextStyle(size: 22)),
//           // 8.height,
//           Text(
//             'Enter your registered email address, and we’ll send you a link to reset your password.',
//             style: secondaryTextStyle(size: 16),
//           ),
//           (Get.height * 0.06).toInt().height,
//
//           // Email Form
//           Form(
//             key: controller.forgetPasswordFormKey,
//             child: AppTextFieldWithLabelComponent(
//               label: "email",
//               appTextField: AppTextField(
//                 textFieldType: TextFieldType.EMAIL_ENHANCED,
//                 controller: controller.emailCont,
//                 isValidationRequired: true,
//                 errorThisFieldRequired: "email Required",
//                 errorInvalidEmail: "Invalid",
//                 decoration: appInputDecoration(
//                   context: context,
//                   prefixIcon: AppIconWidget(icon: Icons.email_outlined),
//                   hintText: 'eg. example@gmail.com',
//                 ),
//               ),
//               isRequiredField: true,
//             ),
//           ),
//
//           32.height,
//
//           // Submit Button
//           AppButtonWidget(
//             text: "Submit",
//             onTap: () {
//               hideKeyboard(context);
//               // controller.handleForgetPassword();
//             },
//           ),
//
//           (Get.height * 0.40).toInt().height,
//         ],
//       ).paddingSymmetric(horizontal: 24),
//     );
//   }
// }
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Forgot your password", style: boldTextStyle(size: 22)),
              16.height,
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
              24.height,
              AppButtonWidget(
                buttonColor: AppColors.whiteColor,
                textColor: AppColors.primary,
                text: "Back to Login",
                width: double.infinity,
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

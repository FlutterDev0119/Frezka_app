// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:nb_utils/nb_utils.dart';
// import '../../../colors.dart';
// import '../../../common_base.dart';
// import '../../../routes/app_pages.dart';
// import '../controllers/login_controller.dart';
//
// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});
//
//   final LoginController loginController = Get.put(LoginController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBF8FF),
//       body: Obx(
//         () => SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset(
//                 "assets/images/signin.png",
//                 fit: BoxFit.contain,
//                 errorBuilder: (context, error, stackTrace) =>
//                     const Icon(Icons.g_mobiledata_rounded),
//               ),
//               // SizedBox(height: Get.height * 0.015),
//               Text(
//                 "Choose Your Role",
//                 style: boldTextStyle(size: 22),
//               ),
//               8.height,
//               Text(
//                 'Welcome To Paiseleyy',
//                 style: secondaryTextStyle(size: 14),
//               ),
//               SizedBox(height: Get.height * 0.02),
//               Form(
//                 key: loginController.signInformKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AppTextField(
//                       textStyle: primaryTextStyle(size: 12),
//                       controller: loginController.emailCont,
//                       focus: loginController.emailFocus,
//                       nextFocus: loginController.passwordFocus,
//                       textFieldType: TextFieldType.EMAIL_ENHANCED,
//                       decoration: inputDecoration(
//                         context,
//                         fillColor: context.cardColor,
//                         filled: true,
//                         hintText: "Email",
//                       ),
//                       suffix: commonLeadingWid(
//                               imgPath: "assets/icons/ic_mail.png",
//                               color: secondaryTextColor,
//                               size: 12)
//                           .paddingAll(16),
//                     ),
//                     16.height,
//                     AppTextField(
//                       textStyle: primaryTextStyle(size: 12),
//                       controller: loginController.passwordCont,
//                       focus: loginController.passwordFocus,
//                       // Optional
//                       textFieldType: TextFieldType.PASSWORD,
//                       decoration: inputDecoration(
//                         context,
//                         fillColor: context.cardColor,
//                         filled: true,
//                         hintText: "password",
//                       ),
//                       suffixPasswordVisibleWidget: commonLeadingWid(
//                               imgPath: "assets/icons/ic_eye.png",
//                               color: secondaryTextColor,
//                               size: 12)
//                           .paddingAll(14),
//                       suffixPasswordInvisibleWidget: commonLeadingWid(
//                               imgPath: "assets/icons/ic_eye_slash.png",
//                               color: secondaryTextColor,
//                               size: 12)
//                           .paddingAll(14),
//                     ),
//                     16.height.visible(loginController.isSendOTP.isTrue),
//                     AppTextField(
//                       textStyle: primaryTextStyle(size: 12),
//                       controller: loginController.otpCont,
//                       focus: loginController.otpFocus,
//                       // Optional
//                       textFieldType: TextFieldType.NUMBER,
//                       decoration: inputDecoration(
//                         context,
//                         fillColor: context.cardColor,
//                         filled: true,
//                         hintText: "OTP",
//                       ),
//                     ).visible(loginController.isSendOTP.isTrue),
//                     8.height,
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.end,
//                     //   children: [
//                     //     TextButton(
//                     //       onPressed: () {
//                     //         // Get.to(() => ForgetPassword());
//                     //       },
//                     //       child: Text(
//                     //         "forgotPassword",
//                     //         style: primaryTextStyle(
//                     //           size: 12,
//                     //           color: appColorPrimary,
//                     //           decoration: TextDecoration.underline,
//                     //           fontStyle: FontStyle.italic,
//                     //           decorationColor: appColorPrimary,
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                   ],
//                 ),
//               ).paddingSymmetric(horizontal: 16),
//               SizedBox(height: Get.height * 0.03),
//               Column(
//                 children: [
//                   Row(
//                     children: [
//                       AppButton(
//                         elevation: 0,
//                         text: loginController.isSendOTP.isTrue
//                             ? "Verify"
//                             : "Sign In",
//                         color: appColorPrimary,
//                         shapeBorder: RoundedRectangleBorder(
//                             borderRadius: radius(defaultAppButtonRadius / 2)),
//                         textStyle: appButtonTextStyleWhite,
//                         onTap: () {
//                           // Get.toNamed(Routes.HOME);
//                           if (loginController.isSendOTP.isTrue) {
//                             loginController.otpVerification();
//                           } else {
//                             if (loginController.signInformKey.currentState!
//                                 .validate()) {
//                               loginController.saveForm();
//                               // Get.toNamed(Routes.HOME);
//                             }
//                           }
//                         },
//                       ).expand(),
//                     ],
//                   ),
//                   8.height,
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text("Not registered?", style: secondaryTextStyle()),
//                       4.width,
//                       TextButton(
//                         style: TextButton.styleFrom(
//                           padding: EdgeInsets.zero,
//                         ),
//                         onPressed: () {
//                           Get.toNamed(Routes.REGISTER);
//                         },
//                         child: Text(
//                           "Register Now",
//                           style: primaryTextStyle(
//                             size: 12,
//                             color: appColorSecondary,
//                             decoration: TextDecoration.underline,
//                             decorationColor: appColorSecondary,
//                           ),
//                         ).paddingSymmetric(horizontal: 8),
//                       ),
//                     ],
//                   ),
//                   8.height,
//                 ],
//               ).paddingSymmetric(horizontal: 16),
//               // commonLeadingWid(
//               //     imgPath: "assets/images/google_logo.png",
//               //     size: 50),
//               SizedBox(height: Get.height * 0.03),
//               Row(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(left: 10.0),
//                     child: const Divider(
//                       color: borderColor,
//                     ),
//                   ).expand(),
//                   Text("Or Sign In With",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey.shade500))
//                       .paddingSymmetric(horizontal: 10),
//                   //primaryTextStyle(color: secondaryTextColor, size: 14)).paddingSymmetric(horizontal: 20),
//                   Container(
//                     margin: const EdgeInsets.only(right: 10.0),
//                     child: const Divider(
//                       color: borderColor,
//                     ),
//                   ).expand(),
//                 ],
//               ),
//               AppButton(
//                 elevation: 2,
//                 width: Get.width,
//                 color: context.cardColor,
//                 text: "",
//                 textStyle: appButtonFontColorText,
//                 onTap: () {
//                   loginController.loginWithGoogle();
//                   // loginController.login();
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       "assets/images/google_logo.png",
//                       height: 25,
//                       width: 25,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) =>
//                           const Icon(Icons.g_mobiledata_rounded),
//                     ),
//                     8.width,
//                     const Text(
//                       "Sign In With Google",
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ).paddingOnly(top: 8, left: 20, right: 20),
//               SizedBox(height: Get.height * 0.03),
//               Obx(
//                 () => Row(
//                   children: [
//                     15.width,
//                     Expanded(
//                         child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: loginController.isRememberMe.value
//                             ? appColorPrimary // Use appColorPrimary here
//                             : Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 15),
//                       ),
//                       child: Text(
//                         'Admin',
//                         style: TextStyle(
//                             color: loginController.isRememberMe.value
//                                 ? Colors.white
//                                 : Colors.black), // Use whiteTextColor
//                       ),
//                       onPressed: () {
//                         // Get.toNamed(Routes.BOTTOMSCREEEN);
//                         loginController.toggleSwitch(); // Select Admin
//                       },
//                     )),
//                     10.width,
//                     Expanded(
//                         child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: loginController.isRememberMe.value
//                             ? Colors.white
//                             : appColorPrimary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 15),
//                       ),
//                       child: Text(
//                         'User',
//                         style: TextStyle(
//                             color: loginController.isRememberMe.value
//                                 ? Colors.black
//                                 : Colors.white), // Use whiteTextColor
//                       ),
//                       onPressed: () {
//                         loginController.toggleSwitch(); // Select Admin
//                       },
//                     )),
//                     15.width,
//                   ],
//                 ),
//               ),
//             ],
//           ).paddingOnly(bottom: 10),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.group, size: 50, color: Colors.blue),
                  const SizedBox(height: 20),

                  // Username Field
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Password Field
                  Obx(() => TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: "Enter your password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          isPasswordVisible.value =
                          !isPasswordVisible.value;
                        },
                      ),
                      border: OutlineInputBorder(),
                    ),
                  )),
                  const SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle login logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text("Login", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Google Sign-in Button
                  GestureDetector(
                    onTap: _signInWithGoogle,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/4/4a/Google_2015_logo.svg',
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Sign in with Google",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Google Sign-In Logic
  Future<void> _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signIn();
      // Handle successful login
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/common/colors.dart';
import '../../../generated/assets.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/common/common.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo/Icon
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.cardColor,
                  child: Icon(Icons.groups, size: 60, color: AppColors.primary),
                ),
                const SizedBox(height: 30),

                Text("Welcome Back!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),

                Text("Login to continue",
                  style: TextStyle(fontSize: 16, color: AppColors.textColor),
                ),
                const SizedBox(height: 30),

                // Username Field
                buildTextField(
                  controller: loginController.emailCont,
                  hintText: "Username",
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),

                // Password Field
                Obx(() => buildTextField(
                  controller: loginController.passwordCont,
                  hintText: "Password",
                  icon: Icons.lock,
                  obscureText: !loginController.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      loginController.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.textColor,
                    ),
                    onPressed: () => loginController.isPasswordVisible.toggle(),
                  ),
                )),
                const SizedBox(height: 15),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(
                      Routes.FORGOTPASSWORD);
                    },
                    child: Text("Forgot Password?",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),

                // Login Button
                _buildButton("Login", 18,FontWeight.bold,AppColors.primary, AppColors.whiteColor,() {
                  loginController.loginUser();
                }),
                const SizedBox(height: 10),

                // Google Sign-In Button
                _buildButton("Sign in with Google", 16,FontWeight.w600,AppColors.whiteColor, AppColors.textColor,() {
                  loginController.loginWithGoogle();
                }, icon: Icons.login),
                const SizedBox(height: 20),

                // Sign-Up Link
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text("Don't have an account? ", style: TextStyle(color: AppColors.textColor)),
                //     GestureDetector(
                //       onTap: () {},
                //       child: Text(
                //         "Sign Up",
                //         style: TextStyle(
                //           color: AppColors.primary,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom Button Widget
  Widget _buildButton(String text, double fontSize,FontWeight fontWeight,Color color,Color textColor, VoidCallback onPressed, {IconData? icon}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: icon != null
            ? SizedBox(
          width: 24,
          height: 24,
          child: Image.asset(Assets.logosIcGoogle, fit: BoxFit.contain),
        )
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: TextStyle(fontSize: fontSize,fontWeight:  fontWeight,color:textColor),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
        ),
      ),
    );

}


}

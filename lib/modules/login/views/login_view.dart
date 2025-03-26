import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../language/languages.dart';
import '../../../main.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isPasswordVisible = false.obs;
  // late BaseLanguage language;
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
                  Column(
                    children: [
                      AppButton(
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius)),
                        onTap: () {
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GoogleLogoWidget(size: 14),Spacer(),
                            Text("Sign in with Google", style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ).center(),
                        elevation: 1,
                        color: context.cardColor,
                      ),
                      // if (isIOS)
                      //   AppButton(
                      //     shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius)),
                      //     onTap: () {
                      //       // appleSignIn();
                      //     },
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Icon(Icons.apple, color: Colors.black, size: 22),
                      //         6.width,
                      //         Text("language.signInWithApple", style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      //       ],
                      //     ),
                      //     elevation: 1,
                      //     color: context.cardColor,
                      //   ).paddingTop(16),
                      // AppButton(
                      //   shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius)),
                      //   onTap: (){},
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Icon(Icons.phone_in_talk, color: context.primaryColor, size: 22),
                      //       6.width,
                      //       Text(language.signInWithOtp, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      //     ],
                      //   ),
                      //   elevation: 1,
                      //   color: context.cardColor,
                      // ).paddingTop(16),
                    ],
                  ).paddingSymmetric(horizontal: 16, vertical: 16),
                  // // Google Sign-in Button
                  // GestureDetector(
                  //   onTap: _signInWithGoogle,
                  //   child: Container(
                  //     width: double.infinity,
                  //     padding: EdgeInsets.symmetric(vertical: 12),
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.grey),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Image.network(
                  //           'https://upload.wikimedia.org/wikipedia/commons/4/4a/Google_2015_logo.svg',
                  //           height: 20,
                  //         ),
                  //         const SizedBox(width: 10),
                  //         Text(
                  //           "Sign in with Google",
                  //           style: TextStyle(fontSize: 16),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
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

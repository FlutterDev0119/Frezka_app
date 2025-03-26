// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:nb_utils/nb_utils.dart';
// import '../../../main.dart';
// import '../controllers/login_controller.dart';
//
// class LoginScreen extends StatelessWidget {
//   LoginController loginController= LoginController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue.shade700,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 5,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.groups, size: 50, color: Colors.blue),
//                   const SizedBox(height: 20),
//
//                   // Username Field
//                   TextField(
//                     controller: loginController.emailCont,
//                     decoration: InputDecoration(
//                       labelText: "Username",
//                       prefixIcon: Icon(Icons.person),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//
//                   // Password Field
//                   Obx(() => TextField(
//                     controller: loginController.passwordCont,
//                     obscureText: !loginController.value,
//                     decoration: InputDecoration(
//                       labelText: "Enter your password",
//                       prefixIcon: Icon(Icons.lock),
//                       suffixIcon: IconButton(
//                         icon: Icon(isPasswordVisible.value
//                             ? Icons.visibility
//                             : Icons.visibility_off),
//                         onPressed: () {
//                           isPasswordVisible.value =
//                           !isPasswordVisible.value;
//                         },
//                       ),
//                       border: OutlineInputBorder(),
//                     ),
//                   )),
//                   const SizedBox(height: 10),
//
//                   // Forgot Password
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Forgot Password?",
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                     ),
//                   ),
//
//                   // Login Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Handle login logic
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue.shade700,
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                       ),
//                       child: Text(
//                         "Login",
//                           style: TextStyle(fontSize: 16, color: white)),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Column(
//                     children: [
//                       AppButton(
//                         shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius)),
//                         onTap: () {
//                           _signInWithGoogle();
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             GoogleLogoWidget(size: 14),
//                             6.width,
//                             Text(locale.value.signInWithGoogle, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
//                           ],
//                         ).center(),
//                         elevation: 1,
//                         color: context.cardColor,
//                       ),
//                       // if (isIOS)
//                       //   AppButton(
//                       //     shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius)),
//                       //     onTap: () {
//                       //       // appleSignIn();
//                       //     },
//                       //     child: Row(
//                       //       mainAxisAlignment: MainAxisAlignment.center,
//                       //       crossAxisAlignment: CrossAxisAlignment.center,
//                       //       children: [
//                       //         Icon(Icons.apple, color: Colors.black, size: 22),
//                       //         6.width,
//                       //         Text("language.signInWithApple", style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
//                       //       ],
//                       //     ),
//                       //     elevation: 1,
//                       //     color: context.cardColor,
//                       //   ).paddingTop(16),
//                       // AppButton(
//                       //   shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius)),
//                       //   onTap: (){},
//                       //   child: Row(
//                       //     mainAxisAlignment: MainAxisAlignment.center,
//                       //     crossAxisAlignment: CrossAxisAlignment.center,
//                       //     children: [
//                       //       Icon(Icons.phone_in_talk, color: context.primaryColor, size: 22),
//                       //       6.width,
//                       //       Text(language.signInWithOtp, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
//                       //     ],
//                       //   ),
//                       //   elevation: 1,
//                       //   color: context.cardColor,
//                       // ).paddingTop(16),
//                     ],
//                   ).paddingSymmetric(horizontal: 16, vertical: 16),
//                   // // Google Sign-in Button
//                   // GestureDetector(
//                   //   onTap: _signInWithGoogle,
//                   //   child: Container(
//                   //     width: double.infinity,
//                   //     padding: EdgeInsets.symmetric(vertical: 12),
//                   //     decoration: BoxDecoration(
//                   //       border: Border.all(color: Colors.grey),
//                   //       borderRadius: BorderRadius.circular(8),
//                   //     ),
//                   //     child: Row(
//                   //       mainAxisAlignment: MainAxisAlignment.center,
//                   //       children: [
//                   //         Image.network(
//                   //           'https://upload.wikimedia.org/wikipedia/commons/4/4a/Google_2015_logo.svg',
//                   //           height: 20,
//                   //         ),
//                   //         const SizedBox(width: 10),
//                   //         Text(
//                   //           "Sign in with Google",
//                   //           style: TextStyle(fontSize: 16),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Google Sign-In Logic
//   Future<void> _signInWithGoogle() async {
//     final GoogleSignIn googleSignIn = GoogleSignIn();
//     try {
//       await googleSignIn.signIn();
//       // Handle successful login
//     } catch (error) {
//       print("Google Sign-In Error: $error");
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

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
                  Icon(Icons.groups, size: 50, color: Colors.blue),
                  const SizedBox(height: 20),

                  // Username Field
                  TextField(
                    controller: loginController.emailCont,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Password Field
                  Obx(() => TextField(
                    controller: loginController.passwordCont,
                    obscureText: !loginController.isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: "Enter your password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(loginController.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          loginController.isPasswordVisible.toggle();
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
                        loginController.saveForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Google Sign-In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.login, color: Colors.white),
                      label: Text("Sign in with Google", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        loginController.loginWithGoogle();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        padding: EdgeInsets.symmetric(vertical: 12),
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
}

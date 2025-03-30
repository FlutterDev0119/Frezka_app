// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../routes/app_pages.dart';
// import '../controllers/login_controller.dart';
//
// class LoginScreen extends StatelessWidget {
//   final LoginController loginController = Get.put(LoginController());
//
//    LoginScreen({super.key});
//
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
//                     obscureText: !loginController.isPasswordVisible.value,
//                     decoration: InputDecoration(
//                       labelText: "Enter your password",
//                       prefixIcon: Icon(Icons.lock),
//                       suffixIcon: IconButton(
//                         icon: Icon(loginController.isPasswordVisible.value
//                             ? Icons.visibility
//                             : Icons.visibility_off),
//                         onPressed: () {
//                           loginController.isPasswordVisible.toggle();
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
//                         Get.toNamed(Routes.GENAICLINICAL);
//                         // loginController.saveForm();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue.shade700,
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                       ),
//                       child: Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//
//                   // Google Sign-In Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       icon: Icon(Icons.login, color: Colors.white),
//                       label: Text("Sign in with Google", style: TextStyle(color: Colors.white)),
//                       onPressed: () {
//                         loginController.loginWithGoogle();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red.shade700,
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.groups, size: 80, color: Colors.blue),
                const SizedBox(height: 30),

                // Username Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Username",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),

                // Username Field
                TextField(
                  controller: loginController.emailCont,
                  decoration: InputDecoration(
                    hintText: "Username",
                    suffixIcon: Icon(Icons.person, color: Colors.grey),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Password Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),

                // Password Field
                Obx(() => TextField(
                  controller: loginController.passwordCont,
                  obscureText: !loginController.isPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginController.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        loginController.isPasswordVisible.toggle();
                      },
                    ),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                )),
                const SizedBox(height: 15),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
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
                      Get.toNamed(Routes.DASHBOARD);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 14),
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
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Custom TextField Widget
import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

import '../shared_prefences.dart';
import 'colors.dart';
import '../library.dart';

// Custom Text Field Widget
Widget buildTextField({
  required TextEditingController controller,
  required String hintText,
  required IconData icon,
  bool obscureText = false,
  Widget? suffixIcon,
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    cursorColor: appBackGroundColor,
    cursorWidth: 1,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: appTextFieldHintColor),
      prefixIcon: Icon(icon, color: appBackGroundColor),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: appWhiteColor,
      // All border styles unified
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appTextFieldHintColor), // Default border
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appTextFieldHintColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appBackGroundColor, width: 1), // Highlight when focused
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
    ),
  );

}
Future<void> loadLoggedInUser() async {
  if (getBoolAsync(AppSharedPreferenceKeys.isUserLoggedIn)) {
    String? jsonString = getStringAsync(AppSharedPreferenceKeys.currentUserData);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final decoded = jsonDecode(jsonString);
        final userData = UserDataResponseModel.fromJson(decoded);
        loggedInUser.value = userData;
        apiToken = userData.access ?? '';
        isLoggedIn(true);
      } catch (e) {
        log('Failed to decode stored user data: $e');
        isLoggedIn(false);
      }
    }
  }
}

RxString selectedLanguageCode = DEFAULT_LANGUAGE.obs;
Rx<UserDataResponseModel> loggedInUser = UserDataResponseModel().obs;
RxBool isLoggedIn = false.obs;
String apiToken = '';
ListAnimationType commonListAnimationType = ListAnimationType.None;
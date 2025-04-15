// Custom TextField Widget
import 'package:nb_utils/nb_utils.dart';

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

RxString selectedLanguageCode = DEFAULT_LANGUAGE.obs;
Rx<UserDataResponseModel> loggedInUser = UserDataResponseModel().obs;
RxBool isLoggedIn = false.obs;
String apiToken = '';
ListAnimationType commonListAnimationType = ListAnimationType.None;
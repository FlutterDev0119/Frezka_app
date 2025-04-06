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
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: AppColors.primary),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: AppColors.cardColor,
    ),
  );
}

RxString selectedLanguageCode = DEFAULT_LANGUAGE.obs;
Rx<UserDataResponseModel> loggedInUser = UserDataResponseModel().obs;
RxBool isLoggedIn = false.obs;
String apiToken = '';
ListAnimationType commonListAnimationType = ListAnimationType.None;
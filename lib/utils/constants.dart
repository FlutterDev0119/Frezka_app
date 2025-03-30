import '../modules/login/model/login_model.dart';
import 'library.dart';

const appTitle = "Sale";
RxBool isLoggedIn = false.obs;
Rx<UserData> loginUserData = UserData().obs;


//User Key Alias
class UserKeys {
  static String firstName = 'first_name';
  static String lastName = 'last_name';
  static String userType = 'user_type';
  static String username = 'username';
  static String email = 'email';
  static String password = 'password';
  static String mobile = 'mobile';
  static String address = 'address';
  static String displayName = 'display_name';
  static String profileImage = 'profile_image';
  static String oldPassword = 'old_password';
  static String newPassword = 'new_password';
  static String loginType = 'login_type';
  static String contactNumber = 'contact_number';
}

class SharedPreferenceConst {
  static const IS_LOGGED_IN = 'IS_LOGGED_IN';
  static const USER_DATA = 'USER_LOGIN_DATA';
  static const uniqueKey = 'uniqueKey';
  static const USER_EMAIL = 'USER_EMAIL';
  static const USER_PASSWORD = 'USER_PASSWORD';
  static const API_TOKEN = 'API_TOKEN';
  static const DESIGN_NUMBERS = 'DESIGN_NUMBERS';
}


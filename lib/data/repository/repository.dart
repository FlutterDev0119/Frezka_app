// import 'package:getx/utils/library.dart';
//
// class Repository{
// static ApiProvider provider = ApiProvider();
// Future<LoginResponse?> loginAPI({required String loginEmail, required String loginPass}) =>
//     provider.loginPost(loginEmail, loginPass);
// }


///Login
// http://127.0.0.1:8000/api/login
//     {
// "email": "dev.rinkulptl@gmail.com",
// "password": "password123",
// "otp": 6094
// }


///send otp
//http://127.0.0.1:8000/api/send-otp
// {
// "email": "dev.rinkulptl@gmail.com"
// }


///Register
// http://127.0.0.1:8000/api/register
//     {
// "first_name": "John",
// "last_name": "Doe",
// "username": "Doe1",
// "email": "dev.rinkulptl@gmail.com",
// "password": "password123",
// "confirm_password": "password123"
// }
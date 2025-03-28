import 'package:apps/routes/app_pages.dart';
import 'package:apps/utils/constants.dart';
import 'package:apps/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:nb_utils/nb_utils.dart';
import 'colors.dart';
import 'language/language_en.dart';
import 'language/languages.dart';
import 'modules/login/model/common_model.dart';

Rx<BaseLanguage> locale = LanguageEn().obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize(aLocaleLanguageList: languageList());
  // Fetch token during app initialization
  final token = await getValueFromLocal(SharedPreferenceConst.API_TOKEN)as String?;
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Frezka",
      initialRoute: (token == null || token =="")
          ? AppPages.initial
          : AppPages.initialHome,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: secondaryTextStyle(
            color: white,
            size: 18,
            weight: FontWeight.w500,
          ),
          color: appColorPrimary,
        ),
      ),
      getPages: AppPages.routes,
    );
  }
}

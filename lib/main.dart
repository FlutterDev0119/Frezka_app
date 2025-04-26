import 'package:apps/utils/common/common.dart';
import 'package:apps/utils/library.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

Rx<BaseLanguage> locale = LanguageEn().obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initialize(aLocaleLanguageList: languageList());
    await loadLoggedInUser();
  } catch (e, stack) {
    print("Initialization failed: $e\n$stack");
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MediObserve",
      initialRoute: AppPages.initial,
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold),
          displayMedium: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold),
          displaySmall: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold),
          headlineLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
          headlineMedium: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
          headlineSmall: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600),
          titleLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
          titleMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
          bodyLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.normal),
          bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),
          labelLarge: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.normal),
        ),
      ),
      getPages: AppPages.routes,
    );
  }
}

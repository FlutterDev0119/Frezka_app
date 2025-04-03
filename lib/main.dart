import 'package:apps/utils/library.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
Rx<BaseLanguage> locale = LanguageEn().obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize(aLocaleLanguageList: languageList());
  // Fetch token during app initialization
  final token =
      await getValueFromLocal(SharedPreferenceConst.API_TOKEN) as String?;
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MediObserve",
      initialRoute: (token == null || token == "")
          ? AppPages.initial
          : AppPages.initialHome,
      // theme: ThemeData.light(useMaterial3: true),
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge:
              GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold),
          displayMedium:
              GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold),
          displaySmall:
              GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold),
          headlineLarge:
              GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
          headlineMedium:
              GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
          headlineSmall:
              GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600),
          titleLarge:
              GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
          titleMedium:
              GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
          bodyLarge:
              GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.normal),
          bodyMedium:
              GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.normal),
          labelLarge:
              GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.normal),
        ),
      ),

      // theme: ThemeData(
      //   appBarTheme: AppBarTheme(
      //     titleTextStyle: secondaryTextStyle(
      //       color: white,
      //       size: 18,
      //       weight: FontWeight.w500,
      //     ),
      //     color: appColorPrimary,
      //   ),
      // ),
      getPages: AppPages.routes,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/common/colors.dart';
import '../../../utils/component/loader_widget.dart';
import '../../../utils/component/no_data_component.dart';
import '../../../utils/local_storage.dart';
import '../../../utils/shared_prefences.dart';
import '../controllers/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.appBackground,
        //appBackGroundColor,
        appBar: buildAppBar(context),
        drawer: buildDrawer(context),
        body: Obx(
          () {
            if (controller.email.value.isEmpty) {
              return Center(child: LoaderWidget());
            } else {
              return buildBody(context);
            }
          },
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Dashboard", style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: appWhiteColor),),
      backgroundColor: appBackGroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: appWhiteColor),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        Obx(() {
          return CircleAvatar(
            backgroundColor: appWhiteColor,
            child: Text(
              controller.firstLetter.value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: appBackGroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
        15.width,
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (controller.items.isEmpty) {
            return NoDataComponent(
              title: 'No TestCases found to filter',
              onRetry: () {},
            );
          }
          int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          List<Map<String, dynamic>> itemsWithWelcome = [
            {"type": "welcome"},
            ...controller.items
          ];
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 285,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: itemsWithWelcome.length,
            itemBuilder: (context, index) {
              var item = itemsWithWelcome[index];
              return item['type'] == "welcome" ? _buildWelcomeCard(context) : _buildCard(context,item);
            },
          );
        },
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: appBackGroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: appDashBoardCardColor,
                  child: Text(
                    controller.firstLetter.value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: appBackGroundColor,
                      fontWeight: FontWeight.bold, // Optional if not defined in theme
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  controller.fullName.value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: appWhiteColor,
                  ),
                ),
                Text(
                  controller.email.value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appWhiteColor.withOpacity(0.7),
                  ),
                ),
              ],

            ),
          ),
          _buildDrawerItem(context, Icons.smart_toy_rounded, "My Agent", Routes.MYAGENT),
          _buildDrawerItem(context, Icons.health_and_safety_rounded, "Engage AI", Routes.ENGAGEAI),
          _buildDrawerItem(context, Icons.translate_rounded, "Metaphrase PV", Routes.META_PHRASE_PV),
          _buildDrawerItem(context, Icons.bar_chart_rounded, "GenAI PV", Routes.GENAIPV),
          _buildDrawerItem(context, Icons.local_hospital_rounded, "GenAI Clinical", Routes.GENAICLINICAL),
          _buildDrawerItem(context, Icons.sync_rounded, "ReconAI", Routes.RECONAI),
          _buildDrawerItem(context, Icons.security_rounded, "GovernAI", Routes.GOVERNAI),
          _buildDrawerItem(context, Icons.admin_panel_settings_rounded, "Prompt Admin", Routes.PROMPTADMIN),
          _buildDrawerItem(context, Icons.language_rounded, "Translation Memory", Routes.TRANSLATIONMEMORY),
          _buildDrawerItem(context, Icons.settings_rounded, "System Configuration", Routes.SYSTEMCONFIGURATION),

          _buildDrawerItem(context,Icons.logout, "Logout", '/login', color: appBackGroundColor, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,IconData icon, String title, String route, {Color color = appBackGroundColor, bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: appTextColor),
      ),

      // onTap: () => isLogout ? Get.offAllNamed(route) : Get.toNamed(route),
      onTap: () async {
        if (isLogout) {
          // Clear shared preferences or cached data
          await clearUserData();

          // Redirect to login and remove all previous routes
          Get.offAllNamed(route);
        } else {
          Get.toNamed(route);
        }
      },
    );
  }

  Future<void> clearUserData() async {
    await setValue(AppSharedPreferenceKeys.isUserLoggedIn, false);
    await setValue(AppSharedPreferenceKeys.apiToken, '');
    await setValue(AppSharedPreferenceKeys.currentUserData, '');
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: appWhiteColor,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Logout Confirmation',
                        style: TextStyle(
                          color: appBackGroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      12.height,
                      const Text(
                        'Are you sure you want to log out?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      24.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppButton(
                            textStyle: TextStyle(color: appBackGroundColor),
                            onTap: () {
                              Get.back();
                            },
                            child: Text('Cancel'),
                          ),
                          AppButton(
                            color: appBackGroundColor,
                            onTap: () async {
                              await clearUserData().then(
                                (value) {
                                  Get.offAllNamed(Routes.LOGIN);
                                },
                              );
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(color: white),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: Card(
        color: AppColors.appBackground1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: appBackGroundColor, // or AppColors.primary
                child: Text(
                  controller.firstLetter.value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: appWhiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24, // You can override font size here
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Welcome",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: appTextColor,
                ),
              ),
              Marquee(
                child: Text(
                  controller.fullName.value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 16,
                    color: appTextColor,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "22/03/2025, 17:26:45",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: appTextColor.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,Map<String, dynamic> item) {
    return GestureDetector(
        onTap: () => Get.toNamed(item['route']),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // elevation: 10,
          shadowColor:appBackGroundColor.withOpacity(0.3), //AppColors.primary.withOpacity(0.3),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.appBackground1, AppColors.appBackground1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: appBackGroundColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [AppColors.appBackground3, AppColors.appBackground3],
                      center: Alignment.center,
                      radius: 0.8,
                    ),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Icon(
                    item['icon'],
                    size: 42,
                    color:appBackGroundColor, //AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTitle(context,item['title']),

                const SizedBox(height: 8),
                Text(
                  item['description'],
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildTitle(BuildContext context,String title) {
    // Split the title into two words if possible
    final words = title.split(" ");
    final firstWord = words.isNotEmpty ? words[0] : '';
    final secondWord = words.length > 1 ? words[1] : '';
    return Column(
      children: [
        // First word (larger font)
        Text(
          firstWord,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textColor,
            letterSpacing: 0.8,
            fontWeight: FontWeight.bold, // Optional if already set in theme
          ),
          textAlign: TextAlign.center,
        ),
        if (secondWord.isNotEmpty)
          Marquee(
            child: Text(
              secondWord,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textColor,
                letterSpacing: 0.8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

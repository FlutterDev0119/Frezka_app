import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/common/colors.dart';
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
      appBar: buildAppBar(),
      drawer: buildDrawer(),
      body: buildBody(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Dashboard", style: GoogleFonts.roboto(color:  AppColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 18)),
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.whiteColor),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        CircleAvatar(
          backgroundColor: AppColors.cardColor,
          child: Text("N",
              style: GoogleFonts.roboto(
                  color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          List<Map<String, dynamic>> itemsWithWelcome = [
            {"type": "welcome"},
            ...controller.items
          ];
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 210,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: itemsWithWelcome.length,
            itemBuilder: (context, index) {
              var item = itemsWithWelcome[index];
              return item['type'] == "welcome"
                  ? _buildWelcomeCard()
                  : _buildCard(item);
            },
          );
        },
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.cardColor,
                  child: Text("N",
                      style: GoogleFonts.roboto(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                Text("Nilesh Sonar",
                    style:
                    GoogleFonts.roboto(color: AppColors.textColor, fontSize: 18)),
                Text("nilesh@example.com",
                    style: GoogleFonts.roboto(
                        color: AppColors.textColor.withOpacity(0.7), fontSize: 14)),
              ],
            ),
          ),
          _buildDrawerItem(Icons.smart_toy_rounded, "My Agent", '/my_agent'),
          _buildDrawerItem(Icons.local_hospital_rounded, "GenAI Clinical", '/GenAI_Clinical'),
          _buildDrawerItem(Icons.settings, "Settings", '/settings'),
          _buildDrawerItem(Icons.logout, "Logout", '/login',
              color: AppColors.primary, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, String route,
      {Color color = AppColors.primary, bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: GoogleFonts.roboto(color: AppColors.textColor)),
      onTap: () => isLogout ? Get.offAllNamed(route) : Get.toNamed(route),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      color: AppColors.cardColor,
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
              backgroundColor: AppColors.primary,
              child: Text("NS",
                  style: GoogleFonts.roboto(
                      color: AppColors.cardColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Text("Welcome",
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor)),
            Text("Nilesh Sonar",
                style: GoogleFonts.roboto(
                    fontSize: 16, color: AppColors.textColor)),
            Center(
              child: Text("22/03/2025, 17:26:45",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: AppColors.textColor.withOpacity(0.7))
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => Get.toNamed(item['route']),
      child: Card(
        color: AppColors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item['icon'], size: 40, color: AppColors.primary),
              const SizedBox(height: 10),
              Center(
                  child: Text(item['title'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor))
              ),
              const SizedBox(height: 5),
              Center(
                  child: Text(item['description'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontSize: 14, color: AppColors.textColor))
              ),
            ],
          ),
        ),
      ),
    );
  }
}
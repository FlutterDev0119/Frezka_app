import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white), // ✅ Menu button (Side Drawer)
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              "N", // ✅ Kept top-right avatar
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      drawer: _buildDrawer(), // ✅ Side Menu (Drawer)
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

            // ✅ Insert Welcome Card at index 0 in the list
            List<Map<String, dynamic>> itemsWithWelcome = [
              {"type": "welcome"}, // Special type for Welcome Card
              ...controller.items, // Rest of the dashboard items
            ];

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisExtent: 200,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: itemsWithWelcome.length,
              itemBuilder: (context, index) {
                var item = itemsWithWelcome[index];
                return item['type'] == "welcome"
                    ? _buildWelcomeCard() // ✅ Display Welcome Card at index 0
                    : _buildCard(item);   // ✅ Display normal cards
              },
            );
          },
        ),
      ),
    );
  }

  /// ✅ Side Menu (Drawer)
  Widget _buildDrawer() {
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
                  backgroundColor: Colors.white,
                  child: Text(
                    "N", // User Initial
                    style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Text("Nilesh Sonar", style: TextStyle(color: Colors.white, fontSize: 18)),
                Text("nilesh@example.com", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          // ListTile(
          //   leading: Icon(Icons.home, color: AppColors.primary),
          //   title: Text("Dashboard"),
          //   onTap: () => Get.toNamed('/dashboard'),
          // ),
          ListTile(
            leading: Icon(Icons.smart_toy_rounded, color: AppColors.primary),
            title: Text("My Agent"),
            onTap: () =>Get.toNamed('/my_agent')//Get.toNamed(Routes.DASHBOARD)
          ),ListTile(
            leading: Icon(Icons.local_hospital_rounded, color: AppColors.primary),
            title: Text("GenAI Clinical"),
            onTap: () =>Get.toNamed('/GenAI_Clinical')//Get.toNamed(Routes.DASHBOARD)
          ),
          ListTile(
            leading: Icon(Icons.settings, color: AppColors.primary),
            title: Text("Settings"),
            onTap: () => Get.toNamed('/settings'),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout"),
            onTap: () => Get.offAllNamed('/login'),
          ),
        ],
      ),
    );
  }

  /// ✅ Welcome Card (Now inside the Grid at index 0)
  Widget _buildWelcomeCard() {
    return Card(
      color: AppColors.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    "NS", // User Initials
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor),
                ),
                Text(
                  "Nilesh Sonar", // Replace with actual user name
                  style: TextStyle(fontSize: 16, color: AppColors.textColor),
                ),
                Center(
                  child: Text(
                    "22/03/2025, 17:26:45", // Replace with dynamic time
                    style: TextStyle(fontSize: 14, color: AppColors.textColor.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  /// ✅ Grid Item Card with `onTap`
  Widget _buildCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(item['route']);
      },
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
              SizedBox(height: 10),
              Text(
                item['title'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                item['description'],
                style: TextStyle(fontSize: 14, color: AppColors.textColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

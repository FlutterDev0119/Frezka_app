import '../../../routes/app_pages.dart';
import '../../../utils/library.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  // Set the image as the background of the DrawerHeader
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo3D.jpg'), // Path to your image
                    fit: BoxFit.cover, // Ensure the image covers the entire background
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft, // Align the text to the bottom left of the header
                  child: Text(
                    'House of Paisley',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.7), // Shadow to improve text visibility
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const Center(
          child: Text('Home Page Content'),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ui_practice_2/screens/meta_data_user.dart';
// import 'package:ui_practice_2/screens/role.dart';
// import 'package:ui_practice_2/screens/source_Type.dart';
// import 'package:ui_practice_2/screens/task.dart';
// import 'package:ui_practice_2/screens/verify.dart';
//
// class HomeController extends GetxController {
//   var isChecked = false.obs;
//   var currentIndex = 0.obs;
//   var isSuffixVisible = false.obs;
//   TextEditingController inputController = TextEditingController();
//   var userInput = [
//     "# Adverse Event Reporting",
//     "# Sampling",
//     "# Aggregate Reporting",
//     "# PV Agreements",
//     "# Risk Management",
//   ].obs;
//
//   void toggleIcon() => isChecked.value = !isChecked.value;
//
//   void userSubmittedData() {
//     if (!userInput.contains(inputController.text) && inputController.text.isNotEmpty) {
//       userInput.add(inputController.text);
//       inputController.clear();
//     }
//   }
//
//   void setTextFromList(int index) {
//     if (index >= 0 && index < userInput.length) {
//       inputController.text = userInput[index];
//     }
//   }
//
//   void changeByUser() => isSuffixVisible.value = inputController.text.isNotEmpty;
// }
//
// class HomeScreen extends StatelessWidget {
//   final HomeController controller = Get.put(HomeController());
//
//   final List<Widget> pages = [
//     Role(),
//     SourceType(),
//     MetaDataUser(),
//     Task(),
//     Verify(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Color.fromARGB(230, 243, 247, 248),
//       body: SafeArea(
//         child: ListView(
//           padding: EdgeInsets.all(8.0),
//           children: [
//             Text("Prompt Name", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 83, 130, 161))),
//             SizedBox(height: 10),
//             Obx(() => TextField(
//               controller: controller.inputController,
//               onEditingComplete: controller.userSubmittedData,
//               decoration: InputDecoration(
//                 hintText: "Enter Prompt Name",
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: controller.userSubmittedData,
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(),
//               ),
//             )),
//             SizedBox(height: 10),
//             Obx(() => Wrap(
//               spacing: 2.0,
//               runSpacing: 1.0,
//               children: List.generate(
//                 controller.userInput.length,
//                     (index) => GestureDetector(
//                   onTap: () => controller.setTextFromList(index),
//                   child: Chip(label: Text(controller.userInput[index])),
//                 ),
//               ),
//             )),
//             SizedBox(height: 10),
//             Obx(() => Row(
//               children: [
//                 Text("Inherit", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 83, 130, 161))),
//                 IconButton(
//                   icon: Icon(controller.isChecked.value ? Icons.check_box : Icons.check_box_outline_blank),
//                   onPressed: controller.toggleIcon,
//                 ),
//               ],
//             )),
//             SizedBox(height: 10),
//             Container(
//               height: size.height / 2,
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 215, 219, 238),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 children: [
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 8,
//                     children: [
//                       _buildOption("Role", Icons.person, 2),
//                       _buildOption("Choose Image", Icons.folder, 0),
//                       _buildOption("Click", Icons.camera_alt, 1),
//                       _buildOption("Task", Icons.list_rounded, 3),
//                       _buildOption("Verify", Icons.verified, 4),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Obx(() => Expanded(child: pages[controller.currentIndex.value])),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Align(
//                       alignment: Alignment.bottomRight,
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromARGB(255, 83, 130, 161),
//                         ),
//                         child: Text("Next", style: TextStyle(color: Colors.white)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOption(String label, IconData icon, int index) {
//     return GestureDetector(
//       onTap: () => controller.currentIndex.value = index,
//       child: Container(
//         height: 35,
//         width: 100,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Color.fromARGB(255, 247, 243, 243),
//         ),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 20, color: Color.fromARGB(255, 83, 130, 161)),
//               SizedBox(width: 5),
//               Text(label, style: TextStyle(color: Color.fromARGB(255, 83, 130, 161), fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

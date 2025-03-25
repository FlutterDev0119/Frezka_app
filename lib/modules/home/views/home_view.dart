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
              ListTile(
                leading: const Icon(Icons.shopify_sharp),
                title: const Text('Purchase Order'),
                onTap: () {
                  Get.offAllNamed(Routes.CREATEPUCHASEORDERHOMESCREEN);
                },
              ),
              // ExpansionTile for Job Slips
              ExpansionTile(
                title: const Text('Job Slips'),
                leading: const Icon(Icons.work), // Optional leading icon
                children: <Widget>[
                  ListTile(
                    title: const Text('Job Slips'),
                    onTap: () {
                      Get.offAllNamed(Routes.JOBSLIPS);
                    },
                  ),
                  ListTile(
                    title: const Text('Embroidery Job Slip'),
                    onTap: () {
                      Get.offAllNamed(Routes.HOMEEMBROIDERYJOBSLIPS);
                    },
                  ),
                  ListTile(
                    title: const Text('Stitching Job Slip'),
                    onTap: () {
                      Get.offAllNamed(Routes.HOMESTITCHINGJOBSLIPS);
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Finishing'),
                leading: const Icon(Icons.cloud_done_rounded),
                // Optional leading icon
                children: <Widget>[
                  ListTile(
                    title: const Text('Thread cutting'),
                    onTap: () {
                      Get.offAllNamed(Routes.HOMETHREADCUTTING);
                    },
                  ),
                  ListTile(
                    title: const Text('Press'),
                    onTap: () {
                      Get.offAllNamed(Routes.HOMEPRESS);
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.currency_rupee),
                title: const Text('Costing'),
                onTap: () {
                  Get.offAllNamed(Routes.COSTINGLIST);
                },
              ),
              ExpansionTile(
                title: const Text('Stock'),
                leading: const Icon(Icons.storage_rounded), // Optional leading icon
                children: <Widget>[
                  ListTile(
                    title: const Text('Stock'),
                    onTap: () {
                      Get.offAllNamed(Routes.STOCKLIST);
                    },
                  ),
                  ListTile(
                    title: const Text('Remaining Stock'),
                    onTap: () {
                      Get.offAllNamed(Routes.REMAININGSTOCKLIST);
                    },
                  ),
                  ListTile(
                    title: const Text('Dispatch the stock'),
                    onTap: () {
                      Get.offAllNamed(Routes.DISPATCHSTOCKLIST);
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('LogOut'),
                onTap: () {
                  // loginController.logout();
                },
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

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

// logout_confirmation_dialog.dart
import 'package:flutter/material.dart';
import '../controllers/logout_controller.dart';

class LogoutScreen extends StatelessWidget {
  final LogoutController controller = LogoutController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Logout Confirmation',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        OutlinedButton(
          onPressed: () => controller.cancel(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[700], // Deep blue/teal
          ),
          onPressed: () => controller.logout(context),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

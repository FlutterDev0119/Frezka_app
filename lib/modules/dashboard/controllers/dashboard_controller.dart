import 'dart:math';

import '../../../utils/library.dart';
import '../../../utils/shared_prefences.dart';

class DashboardController extends GetxController {
  // Observable variables to hold the state of email, full name, and first letter
  var email = "".obs;
  var fullName = "".obs;
  var firstLetter = "".obs;

  @override
  void onInit() {
    print("-------------------- INIT");
    super.onInit();
    _getEmail();
  }

  // Fetch email from shared preferences and process it
  void _getEmail() async {
    String? storedEmail = getValueFromLocal(AppSharedPreferenceKeys.userEmail);
    email.value = storedEmail ?? '';
    print("-------------------- ${email.value}");
    if (storedEmail != null && storedEmail.isNotEmpty) {
      _formatNameFromEmail(storedEmail);
    }
  }

  // Format the full name and first letter from the email
  void _formatNameFromEmail(String email) {
    final namePart = email.split('@').first;
    final nameSegments = namePart.split('.');

    // Format the full name (capitalize first letter of each part)
    fullName.value = nameSegments.map((name) {
      return name[0].toUpperCase() + name.substring(1);
    }).join(' ');

    // Get the first letter of the first name
    firstLetter.value = email.isNotEmpty ? email[0].toUpperCase() : '';
  }

  final List<Map<String, dynamic>> items = [
    {
      "title": "My Agent",
      "description": "Intelligent AI-powered agents designed for Pharmacovigilance.",
      "icon": Icons.smart_toy_rounded,
      "route": Routes.MYAGENT
    },
    {
      "title": "Engage AI",
      "description": "A chatbot for patient and investigator engagement.",
      "icon": Icons.health_and_safety_rounded,
      "route": null
    },
    {
      "title": "Metaphrase PV",
      "description": "An Intuitive Platform for Translation Needs.",
      "icon": Icons.translate_rounded,
      "route": Routes.META_PHRASE_PV
    },
    {
      "title": "GenAI PV",
      "description": "AI-powered tool transforming performance data into narratives.",
      "icon": Icons.bar_chart_rounded,
      "route": ""
    },
    {
      "title": "GenAI Clinical",
      "description": "Assists, guides, and automates clinical service rendering.",
      "icon": Icons.local_hospital_rounded,
      "route": Routes.GENAICLINICAL
    },
    {"title": "ReconAI", "description": "Ensures data consistency, detects anomalies & integrates data.", "icon": Icons.sync_rounded, "route": ""},
    {
      "title": "GovernAI",
      "description": "Automates compliance & enhances risk management.",
      "icon": Icons.security_rounded,
      "route": Routes.GOVERNAI
    },
    {
      "title": "Prompt Admin",
      "description": "Centralized prompt management with enforced guidelines.",
      "icon": Icons.admin_panel_settings_rounded,
      "route": Routes.PROMPTADMIN
    },
    {
      "title": "Translation Memory",
      "description": "Improves translation efficiency & cost-effectiveness.",
      "icon": Icons.language_rounded,
      "route": ""
    },
    {
      "title": "System Configuration",
      "description": "Streamlines system setup for real-time optimization.",
      "icon": Icons.settings_rounded,
      "route": ""
    },
  ];
}

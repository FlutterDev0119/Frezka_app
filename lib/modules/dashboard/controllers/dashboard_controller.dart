import '../../../routes/app_pages.dart';
import '../../../utils/library.dart';

class DashboardController extends GetxController {
  final List<Map<String, dynamic>> items = [
    {
      "title": "My Agent",
      "description":
          "Intelligent AI-powered agents designed for Pharmacovigilance.",
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
      "route": ""
    },
    {
      "title": "GenAI PV",
      "description":
          "AI-powered tool transforming performance data into narratives.",
      "icon": Icons.bar_chart_rounded,
      "route": ""
    },
    {
      "title": "GenAI Clinical",
      "description":
          "Assists, guides, and automates clinical service rendering.",
      "icon": Icons.local_hospital_rounded,
      "route": Routes.GENAICLINICAL
    },
    {
      "title": "ReconAI",
      "description":
          "Ensures data consistency, detects anomalies & integrates data.",
      "icon": Icons.sync_rounded,
      "route": ""
    },
    {
      "title": "GovernAI",
      "description": "Automates compliance & enhances risk management.",
      "icon": Icons.security_rounded,
      "route": ""
    },
    {
      "title": "Prompt Admin",
      "description": "Centralized prompt management with enforced guidelines.",
      "icon": Icons.admin_panel_settings_rounded,
      "route":  Routes.PROMPTADMIN
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

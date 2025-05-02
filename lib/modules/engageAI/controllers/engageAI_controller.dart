import 'dart:convert';

import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/common/common.dart';
import '../../../utils/shared_prefences.dart';
import '../model/engageAI.dart';

class EngageAIController extends GetxController {
  final TextEditingController textController = TextEditingController();
  var messages = <ChatMessage>[].obs;
  var isLoading = false.obs;

  RxString fullName = "".obs;
  RxString firstLetter = "".obs;
  int userId = 0;

  @override
  void onInit() {
    super.onInit();
    getEmail(); // When controller initializes, call this
  }

  void getEmail() async {
    String storedEmail = getStringAsync(AppSharedPreferenceKeys.userEmail);
    String jsonString = getStringAsync(AppSharedPreferenceKeys.currentUserData);

// Parse the string to a Map
    Map<String, dynamic> data = json.decode(jsonString);

// Access the user ID
     userId = data['user_serializer']['id'];

    if (storedEmail.isNotEmpty) {
      _formatNameFromEmail(storedEmail);
      // Show greeting after formatting name
      Future.delayed(Duration(milliseconds: 100), () {
        final name = fullName.value;
        if (name.isNotEmpty) {
          messages.insert(
            0,
            ChatMessage(
              message: "Hi $name, How may I assist you today?",
              isUser: false,
            ),
          );
        }
      });
    }
  }

// This processes the email
  void _formatNameFromEmail(String emailData) {
    final namePart = emailData.split('@').first;
    final parts = namePart.split('.');

    String firstName = parts.isNotEmpty ? parts[0] : '';
    String lastName = parts.length > 1 ? parts[1] : '';

    fullName.value = "${_capitalize(firstName)} ${_capitalize(lastName)}";
    firstLetter.value = "${_getFirstLetter(firstName)}${_getFirstLetter(lastName)}";
  }

  String _capitalize(String s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '';

  String _getFirstLetter(String s) => s.isNotEmpty ? s[0].toUpperCase() : '';

  Future<void> sendMessage(String message) async {
    messages.add(ChatMessage(message: message, isUser: true));
    isLoading.value = true;

    final reply = await ChatServiceApi.sendMessage(
      message: message,
      userName: fullName.value,
      userId: userId.toString(),
    );

    if (reply != null) {
      messages.add(ChatMessage(message: reply, isUser: false));
    } else {
      toast("Failed to get reply");
    }
    isLoading.value = false;
  }

  void clearChat() {
    messages.clear();
    toast("Chat cleared");
  }
}

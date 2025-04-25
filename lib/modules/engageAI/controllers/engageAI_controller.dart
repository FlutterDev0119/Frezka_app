import 'package:apps/utils/library.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/shared_prefences.dart';
import '../model/engageAI.dart';

class EngageAIController extends GetxController {
  final TextEditingController textController = TextEditingController();
  var messages = <ChatMessage>[].obs;
  var isLoading = false.obs;

  RxString firstLetter = "".obs;

  @override
  void onInit() {
    super.onInit();
    getEmail(); // When controller initializes, call this
  }

  void getEmail() async {
    String storedEmail = getStringAsync(AppSharedPreferenceKeys.userEmail);
    if (storedEmail.isNotEmpty) {
      _formatNameFromEmail(storedEmail);
    }
  }

// This processes the email
  void _formatNameFromEmail(String emailData) {
    final namePart = emailData.split('@').first;
    final parts = namePart.split('.');

    String firstName = parts.isNotEmpty ? parts[0] : '';
    String lastName = parts.length > 1 ? parts[1] : '';

    firstLetter.value = "${_getFirstLetter(firstName)}${_getFirstLetter(lastName)}";
  }

  String _capitalize(String s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '';

  String _getFirstLetter(String s) => s.isNotEmpty ? s[0].toUpperCase() : '';

  Future<void> sendMessage(String message) async {
    messages.add(ChatMessage(message: message, isUser: true));
    isLoading.value = true;

    final reply = await ChatServiceApi.sendMessage(
      message: message,
      userName: "Sandesh Singhal",
      userId: "2",
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

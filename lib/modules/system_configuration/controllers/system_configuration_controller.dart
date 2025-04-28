import 'package:apps/utils/common/base_controller.dart';
import 'package:apps/utils/library.dart';

class SystemConfigurationController extends BaseController {
  final RxList<String> options = <String>[
    "GenAlpv",
    "Metaphrase",
    "GovernAI",
    "Business Configurations",
    "Session Moniter",
  ].obs;

  RxBool isLoading = false.obs;
  RxString selectedOption = "GenAIpv".obs;
  RxString fileType = "DOCX".obs;
  RxString responseType = "DOCX".obs;
  RxString llmType = "OpenAI".obs;
  RxString modelType = "gpt-4o".obs;
  RxBool refreshOnLogin = false.obs;
  TextEditingController apiKeyController = TextEditingController();
  RxList<TextEditingController> apiKeyControllers = <TextEditingController>[].obs;

  // Metaphrase-related variables
  RxString selectedMetaphraseLLM = "OpenAI".obs;
  RxString selectedMetaphraseModel = "gpt-4o".obs;
  RxBool refreshOnMetaphraseLogin = true.obs;

  RxList<String> metaphraseLLMs = ["OpenAI", "Azure OpenAI", "Custom"].obs;
  RxList<String> metaphraseModels = ["gpt-4o", "gpt-4", "claude-3-opus"].obs;

  // S3 Path fields
  RxString inputFolderPath = "".obs;
  RxString outputFolderPath = "".obs;
  RxString translationMemoryPath = "".obs;

  RxString apiKey = "".obs;
  RxList<TextEditingController> apiKeyMetaphraseControllers = <TextEditingController>[].obs;
  TextEditingController apiKeyMetaphraseController = TextEditingController();

  /// GovernAI-related variables
  RxString selectedGovernAIDRF = "Monthly".obs;
  RxString selectedGovernAILLM = "OpenAI".obs;
  RxString selectedGovernAIModel = "gpt-4o".obs;
  RxBool refreshOnGovernAILogin = true.obs;

  RxList<String> governAIDRF = ["Daily", "Weekly", "Monthly"].obs;
  RxList<String> governAILLMs = ["OpenAI", "Azure OpenAI", "Custom"].obs;
  RxList<String> governAIModels = ["gpt-4o", "o1", "o3-mini","gpt-4o-mini"].obs;

  RxString apiKeyGovernAI = "".obs;
  RxList<TextEditingController> apiKeyGovernAIControllers = <TextEditingController>[].obs;
  TextEditingController apiKeyGovernAIController = TextEditingController();

  /// BusinessAI-related variables
  RxString selectedBusinessTheme = "Light".obs;
  RxString selectedBusinessLLM = "OpenAI".obs;
  RxString selectedBusinessModel = "gpt-4o".obs;
  RxBool refreshOnBusinessLogin = true.obs;

  RxList<String> businessTheme = ["Light", "Dark"].obs;
  RxList<String> businessLLMs = ["OpenAI", "Anthrotic", "DeepSeek","Gemini"].obs;
  RxList<String> businessModels = ["gpt-4o", "o1", "o3-mini","gpt-4o-mini"].obs;

  RxString apiKeyBusiness = "".obs;
  RxList<TextEditingController> apiKeyBusinessControllers = <TextEditingController>[].obs;
  TextEditingController apiKeyBusinessController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    apiKeyControllers.add(TextEditingController());
    apiKeyMetaphraseControllers.add(TextEditingController());
    apiKeyGovernAIControllers.add(TextEditingController());
    apiKeyBusinessControllers.add(TextEditingController());
  }

  void addApiKeyField() {
    apiKeyControllers.add(TextEditingController());
  }

  void addApiKeyMetaphraseField() {
    apiKeyMetaphraseControllers.add(TextEditingController());
  }

  void addApiKeyGovernAIField() {
    apiKeyGovernAIControllers.add(TextEditingController());
  }

  void addApiKeyBusinessAIField() {
    apiKeyBusinessControllers.add(TextEditingController());
  }
}

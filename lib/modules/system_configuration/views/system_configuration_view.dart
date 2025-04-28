import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../generated/assets.dart';
import '../../../utils/common/colors.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/common/common_base.dart';
import '../../../utils/component/image_source_selection_component.dart';
import '../controllers/system_configuration_controller.dart';

class SystemConfigurationScreen extends StatelessWidget {
  final SystemConfigurationController controller = Get.put(SystemConfigurationController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppScaffold(
        appBarBackgroundColor: appBackGroundColor,
        appBarTitleText: "System Configuration",
        appBarTitleTextStyle: TextStyle(
          fontSize: 20,
          color: appWhiteColor,
        ),
        isLoading: controller.isLoading,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Obx(() {
                      if (!controller.options.contains(controller.selectedOption.value)) {
                        controller.selectedOption.value = (controller.options.isNotEmpty ? controller.options.first : null)!;
                      }

                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        value: controller.selectedOption.value,
                        items: controller.options.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.selectedOption.value = newValue;
                          }
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  Obx(() {
                    return controller.selectedOption.value == "GenAlpv"
                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            // Search Field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Title
                            Text(
                              "${controller.selectedOption.value} Configuration",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Access Key & Secret Key fields
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Access Key",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Secret Key",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Upload File Settings
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Upload File Settings",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "File Count",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          value: controller.fileType.value,
                                          items: ["DOCX", "PDF", "TXT"].map((String type) {
                                            return DropdownMenuItem<String>(
                                              value: type,
                                              child: Text(type),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              controller.fileType.value = newValue;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Prompts to Show (Grouping)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Prompts to Show (Grouping)",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: "Enter prompts",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Response View
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Response View",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          value: controller.responseType.value,
                                          items: ["DOCX", "Plaintext"].map((String type) {
                                            return DropdownMenuItem<String>(
                                              value: type,
                                              child: Text(type),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              controller.responseType.value = newValue;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // LLM
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "LLM",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          value: controller.llmType.value,
                                          items: ["OpenAI", "Azure OpenAI", "Custom"].map((String llm) {
                                            return DropdownMenuItem<String>(
                                              value: llm,
                                              child: Text(llm),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              controller.llmType.value = newValue;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Model
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Model",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          value: controller.modelType.value,
                                          items: ["gpt-4o", "gpt-4-turbo", "gpt-3.5-turbo"].map((String model) {
                                            return DropdownMenuItem<String>(
                                              value: model,
                                              child: Text(model),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              controller.modelType.value = newValue;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // API Key
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "API Key",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Obx(() => Column(
                                              children: [
                                                ...controller.apiKeyControllers.map((textController) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 12),
                                                    child: TextField(
                                                      controller: textController,
                                                      decoration: InputDecoration(
                                                        hintText: "Enter API Key",
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                Row(
                                                  children: [
                                                    Expanded(child: SizedBox()), // Pushes button to right
                                                    ElevatedButton(
                                                      onPressed: controller.addApiKeyField,
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.green,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        padding: const EdgeInsets.all(16),
                                                      ),
                                                      child: const Icon(Icons.add, color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Refresh on Login
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Refresh on Login",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Obx(() => Row(
                                              children: [
                                                Radio<bool>(
                                                  value: true,
                                                  groupValue: controller.refreshOnLogin.value,
                                                  onChanged: (bool? value) {
                                                    if (value != null) {
                                                      controller.refreshOnLogin.value = value;
                                                    }
                                                  },
                                                ),
                                                const Text("Yes"),
                                                const SizedBox(width: 16),
                                                Radio<bool>(
                                                  value: false,
                                                  groupValue: controller.refreshOnLogin.value,
                                                  onChanged: (bool? value) {
                                                    if (value != null) {
                                                      controller.refreshOnLogin.value = value;
                                                    }
                                                  },
                                                ),
                                                const Text("No"),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ])
                        : SizedBox();
                  }),

                  ///Metaphrase Configuration
                  Obx(() {
                    return controller.selectedOption.value == "Metaphrase"
                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            // Search Bar
                            _buildSearchBar(),

                            const SizedBox(height: 16),

                            // Title
                            Text(
                              "Metaphrase Configuration",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                            ),

                            const SizedBox(height: 16),

                            // Main Card
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // S3 Paths Section
                                  _buildSectionTitle("S3 Paths"),
                                  const SizedBox(height: 16),
                                  _buildTextField("Input Folder Path", controller.inputFolderPath),
                                  const SizedBox(height: 16),
                                  _buildTextField("Output Folder Path", controller.outputFolderPath),
                                  const SizedBox(height: 16),
                                  _buildTextField("Translation Memory Path", controller.translationMemoryPath),

                                  const SizedBox(height: 24),

                                  // LLM Section
                                  _buildSectionTitle("LLM"),
                                  const SizedBox(height: 16),
                                  _buildDropdown(controller.metaphraseLLMs, "Select LLM", controller.selectedMetaphraseLLM),

                                  const SizedBox(height: 24),

                                  // Model Section
                                  _buildSectionTitle("Model"),
                                  const SizedBox(height: 16),
                                  _buildDropdown(controller.metaphraseModels, "Select Model", controller.selectedMetaphraseModel),

                                  const SizedBox(height: 24),

                                  // API Key Section
                                  _buildSectionTitle("API Key"),
                                  const SizedBox(height: 16),
                                  Obx(() => Column(
                                        children: [
                                          ...controller.apiKeyMetaphraseControllers.map((textController) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 12),
                                              child: TextField(
                                                controller: textController,
                                                decoration: InputDecoration(
                                                  hintText: "Enter API Key",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          Row(
                                            children: [
                                              Expanded(child: SizedBox()), // Pushes button to right
                                              ElevatedButton(
                                                onPressed: controller.addApiKeyMetaphraseField,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  padding: const EdgeInsets.all(16),
                                                ),
                                                child: const Icon(Icons.add, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),

                                  const SizedBox(height: 24),

                                  // Refresh on Login Section
                                  _buildSectionTitle("Refresh on Login"),
                                  const SizedBox(height: 8),
                                  _buildRefreshOnLogin(),
                                ],
                              ),
                            )
                          ])
                        : SizedBox();
                  }),
                  /// GovernAI
                  Obx(() {
                    return controller.selectedOption.value == "GovernAI"
                        ?  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Search Bar
                      _buildSearchBar(),

                      const SizedBox(height: 16),

                      // Title
                      Text(
                        "GovernAI Configuration",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                      ),

                      const SizedBox(height: 16),

                      // Main Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // LLM Section
                            _buildSectionTitle("Date Range Filter"),
                            const SizedBox(height: 16),
                            _buildDropdown(controller.governAIDRF, "Select Date Range Filter", controller.selectedGovernAIDRF),

                            const SizedBox(height: 24),
                            // LLM Section
                            _buildSectionTitle("LLM"),
                            const SizedBox(height: 16),
                            _buildDropdown(controller.governAILLMs, "Select LLM", controller.selectedGovernAILLM),

                            const SizedBox(height: 24),

                            // Model Section
                            _buildSectionTitle("Model"),
                            const SizedBox(height: 16),
                            _buildDropdown(controller.governAIModels, "Select Model", controller.selectedGovernAIModel),

                            const SizedBox(height: 24),

                            // API Key Section
                            _buildSectionTitle("API Key"),
                            const SizedBox(height: 16),
                            Obx(() => Column(
                              children: [
                                ...controller.apiKeyGovernAIControllers.map((textController) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: TextField(
                                      controller: textController,
                                      decoration: InputDecoration(
                                        hintText: "Enter API Key",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                Row(
                                  children: [
                                    Expanded(child: SizedBox()), // Pushes button to right
                                    ElevatedButton(
                                      onPressed: controller.addApiKeyGovernAIField,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                      ),
                                      child: const Icon(Icons.add, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            )),

                            const SizedBox(height: 24),

                            // Refresh on Login Section
                            _buildSectionTitle("Refresh on Login"),
                            const SizedBox(height: 8),
                            _buildRefreshOnLogin(),
                          ],
                        ),
                      )
                    ])
                        : SizedBox();
                  }),
                  Obx(() {
                    return controller.selectedOption.value == "Business Configurations"
                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Search Bar
                      _buildSearchBar(),

                      const SizedBox(height: 16),

                      // Title
                      Text(
                        "Business Configuration",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                      ),

                      const SizedBox(height: 16),

                      // Main Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // LLM Section
                            _buildSectionTitle("LLM"),
                            const SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                hintText: "Enter LLM Key",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                            // Access Key & Secret Key fields
                            _buildSectionTitle("AWS Credentials"),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Access Key",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Secret Key",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Theme Section
                            _buildSectionTitle("Theme"),
                            const SizedBox(height: 16),
                            _buildDropdown(controller.businessTheme, "Select Theme", controller.selectedBusinessTheme),

                            const SizedBox(height: 16),
                            // Database credentials
                            _buildSectionTitle("Database Credentials"),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Database URL",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Database Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),

                            // LLM Section
                            _buildSectionTitle("LLM"),
                            const SizedBox(height: 16),
                            _buildDropdown(controller.businessLLMs, "Select LLM", controller.selectedBusinessLLM),

                            const SizedBox(height: 24),


                            // Model Section
                            _buildSectionTitle("Model"),
                            const SizedBox(height: 16),
                            _buildDropdown(controller.governAIModels, "Select Model", controller.selectedGovernAIModel),

                            const SizedBox(height: 24),

                            // API Key Section
                            _buildSectionTitle("API Key"),
                            const SizedBox(height: 16),
                            Obx(() => Column(
                              children: [
                                ...controller.apiKeyGovernAIControllers.map((textController) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: TextField(
                                      controller: textController,
                                      decoration: InputDecoration(
                                        hintText: "Enter API Key",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                Row(
                                  children: [
                                    Expanded(child: SizedBox()), // Pushes button to right
                                    ElevatedButton(
                                      onPressed: controller.addApiKeyGovernAIField,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                      ),
                                      child: const Icon(Icons.add, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            )),

                            const SizedBox(height: 24),

                            // Refresh on Login Section
                            _buildSectionTitle("Refresh on Login"),
                            const SizedBox(height: 8),
                            _buildRefreshOnLogin(),
                          ],
                        ),
                      )

                    ])
                        : SizedBox();
                  }),
                  Obx(() {
                    return controller.selectedOption.value == "Session Moniter"
                        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [])
                        : SizedBox();
                  }),
                ],
              ),
            ),
          ),
        ));
  }

  /// Metaphrase
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[800]),
    );
  }

  Widget _buildTextField(String hint, RxString controllerValue) {
    return Obx(() => TextField(
          onChanged: (value) {
            controllerValue.value = value;
          },
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          controller: TextEditingController(text: controllerValue.value),
        ));
  }

  Widget _buildDropdown(List<String> items, String hint, RxString selectedValue) {
    return Obx(() => DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          value: selectedValue.value,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              selectedValue.value = newValue;
            }
          },
        ));
  }

  Widget _buildRefreshOnLogin() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text("Yes"),
                value: true,
                groupValue: controller.refreshOnMetaphraseLogin.value,
                onChanged: (bool? value) {
                  if (value != null) {
                    controller.refreshOnMetaphraseLogin.value = value;
                  }
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text("No"),
                value: false,
                groupValue: controller.refreshOnMetaphraseLogin.value,
                onChanged: (bool? value) {
                  if (value != null) {
                    controller.refreshOnMetaphraseLogin.value = value;
                  }
                },
              ),
            ),
          ],
        ));
  }
}

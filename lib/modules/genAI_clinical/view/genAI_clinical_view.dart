import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common/colors.dart';
import '../../../utils/app_scaffold.dart';
import '../controllers/genAI_clinical_controller.dart';

class GeneralClinicController extends GetxController {
  var selectedFile = ''.obs;
}

class GenAIClinicalScreen extends StatelessWidget {
  final GenAIClinicalController controller = Get.put(GenAIClinicalController());

  GenAIClinicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBarBackgroundColor: appBackGroundColor,
        appBarTitleText: "GenAI Clinical",

        appBarTitleTextStyle: TextStyle(
        fontSize: 20,
        color: appWhiteColor,
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Upload File'),
                ),
                10.width,
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select File',
                    ),
                    items: [],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            20.height,
            Text('Ready to Use Prompts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 10,
              children: [
                _buildPromptChip('Batch_Narrative_Generation'),
                _buildPromptChip('Literature Case'),
                _buildPromptChip('Medical Device Case'),
                _buildPromptChip('SUSAR/Fatal/Death'),
                _buildPromptChip('Pregnancy Case'),
                _buildPromptChip('Follow-up Prompt'),
              ],
            ),
            20.height,
            Text('Personalize The Prompt',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter The Prompt',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blue.shade100,
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/genAI_clinical_controller.dart';

class GeneralClinicController extends GetxController {
  var selectedFile = ''.obs;
}

class GenAIClinicalScreen extends StatelessWidget {
  final GenAIClinicalController controller = Get.put(GenAIClinicalController());

  GenAIClinicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Curate The Response'),
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
                SizedBox(width: 10),
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
            SizedBox(height: 20),
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
            SizedBox(height: 20),
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


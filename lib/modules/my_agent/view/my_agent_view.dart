import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/dropdown_tile.dart';
import '../controllers/my_agent_controller.dart';

class MyAgentScreen extends StatelessWidget {
  final MyAgentController controller = Get.put(MyAgentController());

  MyAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "My Agent",
          style: Theme.of(context).textTheme.headlineMedium, // Use theme style
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agent Name Input Field
            TextField(
              decoration: InputDecoration(
                labelText: "Enter Agent Name",
                labelStyle:
                    Theme.of(context).textTheme.bodyLarge, // Use theme style
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Selected Items Container
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Wrap for Selected Items
                  Obx(
                    () => SingleChildScrollView(
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: controller.selectedItems
                            .map(
                              (item) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.red, width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => controller.removeItem(item),
                                      child: const Icon(Icons.close,
                                          color: Colors.red, size: 18),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

                  // Share Button (Positioned Bottom-Right)
                  Obx(
                    () => Positioned(
                      bottom: 1,
                      right: 1,
                      child: GestureDetector(
                        onTap: controller.selectedItems.isNotEmpty
                            ? () {
                                print("Sharing: ${controller.selectedItems}");
                              }
                            : null,
                        child: Image.asset(
                          'assets/icons/send.png',
                          width: 25,
                          height: 25,
                          color: controller.selectedItems.isNotEmpty
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Expansion Tiles
            Expanded(
              child: ListView(
                children: [
                  DropdownTile(
                    title: "Pre-Configured Test Data",
                    items: controller.dropdownItems,
                    controller: controller,
                  ),
                  DropdownTile(
                    title: "Ready To Use Agents",
                    items: controller.agentItems,
                    controller: controller,
                  ),
                  DropdownTile(
                    title: "Additional Test Data 1",
                    items: controller.additionalDropdown1,
                    controller: controller,
                  ),
                  DropdownTile(
                    title: "Additional Test Data 2",
                    items: controller.additionalDropdown2,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

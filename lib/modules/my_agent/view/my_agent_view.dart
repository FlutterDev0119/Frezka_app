import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/common/common_base.dart';
import '../../../utils/dropdown_tile.dart';
import '../../../utils/common/colors.dart';
import '../controllers/my_agent_controller.dart';

class MyAgentScreen extends StatelessWidget {
  final MyAgentController controller = Get.put(MyAgentController());

  MyAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: controller.isLoading,
      appBarBackgroundColor: AppColors.primary,
      appBarTitleText: "My Agent",
      appBarTitleTextStyle: TextStyle(
        fontSize: 20,
        color: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agent Name Input Field
            TextField(
              decoration: appInputDecoration(
                context: context,
                labelText: "Enter Agent Name",
                labelStyle: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 16,
                ),
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
                color: AppColors.cardColor,
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
                                  color: AppColors.appBackground,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppColors.primary, width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => controller.removeItem(item),
                                      child: const Icon(Icons.close,
                                          color: AppColors.redColor, size: 18),
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
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: controller.selectedItems.isNotEmpty
                            ? () {
                                print("Sharing: ${controller.selectedItems}");
                              }
                            : null,
                        child: Image.asset(
                          Assets.iconsSend,
                          width: 25,
                          height: 25,
                          color: controller.selectedItems.isNotEmpty
                              ? AppColors.textColor
                              : AppColors.greyColor,
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

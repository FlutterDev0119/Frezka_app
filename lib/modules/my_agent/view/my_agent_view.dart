import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          icon: Icon(Icons.arrow_back, color: Colors.white), // Change color here
          onPressed: () {
            Get.back(); // Navigate back
          },
        ),
        title: Text("My Agent"),
        backgroundColor: Colors.purple,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Text Field with Border
              TextField(
                decoration: InputDecoration(
                  labelText: "Enter Agent Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // ✅ Scrollable Container (3x height)
              Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                height: 200,
                // Increased height (3x of normal size)
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() => SingleChildScrollView(
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: controller.selectedItems
                            .map(
                              (item) => Container(
                                padding: EdgeInsets.symmetric(
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
                                    Text(item,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => controller.removeItem(item),
                                      child: Icon(Icons.close,
                                          color: Colors.red, size: 18),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )),
              ),

              SizedBox(height: 20),

              // ✅ Dropdown 1: Pre-Configured Test Data
              ExpansionTile(
                title: Text("Pre-Configured Test Data",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                children: controller.dropdownItems
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple),
                          onPressed: () => controller.addItem(item),
                          child:
                              Text(item, style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                    .toList(),
              ),

              // ✅ Dropdown 2: Ready to Use Agents
              ExpansionTile(
                title: Text("Ready To Use Agents",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                children: controller.agentItems
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple),
                          onPressed: () => controller.addItem(item),
                          child:
                              Text(item, style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                    .toList(),
              ),

              // ✅ Additional Dropdown 1
              ExpansionTile(
                title: Text("Additional Test Data 1",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                children: controller.additionalDropdown1
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple),
                          onPressed: () => controller.addItem(item),
                          child:
                              Text(item, style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                    .toList(),
              ),

              // ✅ Additional Dropdown 2
              ExpansionTile(
                title: Text("Additional Test Data 2",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                children: controller.additionalDropdown2
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple),
                          onPressed: () => controller.addItem(item),
                          child:
                              Text(item, style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

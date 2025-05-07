
import 'package:apps/utils/library.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_scaffold.dart';
import '../../../utils/component/image_source_selection_component.dart';
import '../controllers/reconAI_controller.dart';

class ReconAIScreen extends StatelessWidget {
  final ReconAIController controller = Get.put(ReconAIController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: controller.isLoading,
      appBarBackgroundColor: appBackGroundColor,
      appBarTitleText: "Recon AI",
      appBarTitleTextStyle: TextStyle(fontSize: 20, color: appWhiteColor),
      body: Container(
        color: AppColors.appBackground,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Source & Target Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source Section
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: appDashBoardCardColor, // Light background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.cloud_upload_outlined, color: Colors.blue),
                              8.width,
                              Text('Source', style: boldTextStyle()),
                            ],
                          ),
                          12.height,
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: appBackGroundColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Obx(() => DropdownButton<String>(
                                  value: controller.sourceDropdownValue.value,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  items: ['Upload File', 'Data Lake'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: primaryTextStyle()),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    controller.sourceDropdownValue.value = newValue!;
                                  },
                                )),
                              ),
                              10.height,
                              // Query Input
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() {
                                        final files = controller.fileNames;

                                        if (files.isEmpty) {
                                          return Text('Select File', style: primaryTextStyle());
                                        }

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: files.map((file) {
                                            return Row(
                                              children: [
                                                Icon(Icons.insert_drive_file, color: appBackGroundColor, size: 18),
                                                6.width,
                                                Expanded(
                                                  child: Text(
                                                    file,
                                                    style: primaryTextStyle(),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ).paddingBottom(4);
                                          }).toList(),
                                        );
                                      }),
                                    ),



                                    // Expanded(
                                    //   child: Text(
                                    //     'Select File',
                                    //     style: primaryTextStyle(),
                                    //     overflow: TextOverflow.ellipsis,
                                    //   ),
                                    // ),
                                    5.width,
                                    GestureDetector(
                                      onTap: () {
                                        controller.sourceDropdownValue.value == 'Upload File' ? Get.bottomSheet(
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          ImageSourceSelectionComponent(
                                            onSourceSelected: (imageSource) {
                                              hideKeyboard(context);
                                              controller.onSourceSelected(imageSource);
                                            },
                                          ),
                                        ):SizedBox();
                                      },
                                      child: Obx(() {
                                        // Dynamically change icon based on dropdown value
                                        IconData icon = controller.sourceDropdownValue.value == 'Upload File'
                                            ? Icons.attach_file
                                            : Icons.cloud;
                                        return Icon(icon, color: appBackGroundColor);
                                      }),
                                    ),
                                    5.width,
                                    Obx(() {
                                      return controller.sourceDropdownValue.value == 'Upload File'
                                          ? SizedBox()
                                          : Icon(Icons.file_copy_rounded, color: appBackGroundColor);
                                    }),

                                  ],
                                ),
                              ),
                            ],
                          ),
          
                          12.height,
                          // Buttons
                          Row(
                            children: [
                              AppButton(
                                text: '#Report',
                                color: appBackGroundColor,
                                textColor: Colors.white,
                                onTap: () {},
                              ),
                              8.width,
                              AppButton(
                                text: '#Source data',
                                color: appBackGroundColor,
                                textColor: Colors.white,
                                onTap: () {},
                              ),
                            ],
                          ),
          
                          20.height,
                          // Target Section
          
                          Row(
                            children: [
                              Icon(Icons.cloud_done_outlined, color: Colors.green),
                              8.width,
                              Text('Target', style: boldTextStyle()),
                            ],
                          ),
                          12.height,
                          Column(
                            children: [
                              // Dropdown
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: appBackGroundColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Obx(() => DropdownButton<String>(
                                  value: controller.targetDropdownValue.value,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  items: ['Upload File', 'Data Lake'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: primaryTextStyle()),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    controller.targetDropdownValue.value = newValue!;
                                  },
                                )),
                              ),
                              10.height,
                              // Query Input
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Select File',
                                        style: primaryTextStyle(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    5.width,
                                    GestureDetector(
                                      onTap: () {
                                        Get.bottomSheet(
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          ImageSourceSelectionComponent(
                                            onSourceSelected: (imageSource) {
                                              hideKeyboard(context);
                                              log("-------------------------241------------------");
                                              controller.onSourceSelected(imageSource);
                                            },
                                          ),
                                        );
                                      },
                                      child: Obx(() {
                                        // Dynamically change icon based on dropdown value
                                        IconData icon = controller.targetDropdownValue.value == 'Upload File'
                                            ? Icons.attach_file
                                            : Icons.cloud;
                                        return Icon(icon, color:appBackGroundColor);
                                      }),
                                    ),
                                    5.width,
                                    Obx(() {
                                      return controller.targetDropdownValue.value == 'Upload File'
                                          ? SizedBox()
                                          : GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: Get.context!,
                                            builder: (_) => AlertDialog(
                                              title: Text("Box"),
                                              content: Text("Open Box"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: Text("Close"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Icon(Icons.file_copy_rounded, color: appBackGroundColor),
                                      );
                                    }),

                                  ],
                                ),
                              ),
                            ],
                          ),
          
                          // Row(
                          //   children: [
                          //     // Dropdown
                          //     Expanded(
                          //       child: Container(
                          //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          //         decoration: BoxDecoration(
                          //           border: Border.all(color: appBackGroundColor),
                          //           borderRadius: BorderRadius.circular(8),
                          //         ),
                          //         child: Obx(() => DropdownButton<String>(
                          //               value: controller.targetDropdownValue.value,
                          //               isExpanded: true,
                          //               underline: SizedBox(),
                          //               items: ['Upload File', 'Data Lake'].map((String value) {
                          //                 return DropdownMenuItem<String>(
                          //                   value: value,
                          //                   child: Text(value, style: primaryTextStyle()),
                          //                 );
                          //               }).toList(),
                          //               onChanged: (newValue) {
                          //                 controller.targetDropdownValue.value = newValue!;
                          //               },
                          //             )),
                          //       ),
                          //     ),
                          //     10.width,
                          //     // Query Input
                          //     Expanded(
                          //       child: Container(
                          //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          //         decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius: BorderRadius.circular(8),
                          //         ),
                          //         child: Row(
                          //           children: [
                          //             Expanded(
                          //               child: Text(
                          //                 'Select File',
                          //                 style: primaryTextStyle(),
                          //                 overflow: TextOverflow.ellipsis,
                          //               ),
                          //             ),
                          //             GestureDetector(onTap: (){Get.bottomSheet(
                          //               enableDrag: true,
                          //               isScrollControlled: true,
                          //               ImageSourceSelectionComponent(
                          //                 onSourceSelected: (imageSource) {
                          //                   hideKeyboard(context);
                          //                   controller.onSourceSelected(imageSource);
                          //                 },
                          //               ),
                          //             );},child: Icon(Icons.attach_file, color: Colors.blueGrey)),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          12.height,
                          // Buttons
                          Row(
                            children: [
                              AppButton(
                                text: '#Report',
                                color: appBackGroundColor,
                                textColor: Colors.white,
                                onTap: () {},
                              ),
                              8.width,
                              AppButton(
                                text: '#Source data',
                                color: appBackGroundColor,
                                textColor: Colors.white,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: appDashBoardCardColor, // Light background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("MetaData", style: boldTextStyle(color: appBackGroundColor)),
                          12.height,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Select File',
                                    style: primaryTextStyle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(onTap: (){
                                  Get.bottomSheet(
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  ImageSourceSelectionComponent(
                                    onSourceSelected: (imageSource) {
                                      hideKeyboard(context);
                                      controller.onSourceSelected(imageSource);
                                    },
                                  ),
                                );},child: Icon(Icons.attach_file, color: appBackGroundColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'common/colors.dart';
import '../network/config.dart';
import 'component/app_body.dart';
import 'component/loader_widget.dart';

class AppScaffold extends StatelessWidget {
  final bool hideAppBar;

  //
  final Widget? leadingWidget;
  final Widget? appBarTitle;
  final List<Widget>? actions;
  final bool isCenterTitle;
  final bool automaticallyImplyLeading;
  final double? appBarElevation;
  final String? appBarTitleText;

  final TextStyle? appBarTitleTextStyle;
  final Color? appBarBackgroundColor;

  //
  final Widget body;
  final Color? scaffoldBackgroundColor;
  final RxBool? isLoading;

  final RxInt? currentPage;

  //
  final Widget? bottomNavBar;
  final Widget? floatingWidget;
  final bool hasLeadingWidget;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final bool resizeToAvoidBottomPadding;

  final bool showFloatingButton;

  const AppScaffold({
    Key? key,
    this.hideAppBar = false,
    //
    this.leadingWidget,
    this.appBarTitle,
    this.actions,
    this.appBarElevation = 0,
    this.appBarTitleText,
    this.appBarBackgroundColor,
    this.isCenterTitle = false,
    this.hasLeadingWidget = true,
    this.automaticallyImplyLeading = false,
    this.appBarTitleTextStyle,
    //
    required this.body,
    this.isLoading,
    this.currentPage,
    //
    this.bottomNavBar,
    this.floatingWidget,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.centerFloat,
    this.resizeToAvoidBottomPadding = false,
    this.scaffoldBackgroundColor,
    this.showFloatingButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
      appBar: hideAppBar
          ? null
          : PreferredSize(
              preferredSize: Size(Get.width, 66),
              child: AppBar(
                elevation: appBarElevation,
                automaticallyImplyLeading: automaticallyImplyLeading,
                backgroundColor: appBarBackgroundColor ?? context.cardColor,
                centerTitle: isCenterTitle,
                titleSpacing: 2,
                title: appBarTitle ??
                    Text(
                      appBarTitleText ?? "",
                      style: appBarTitleTextStyle ?? boldTextStyle(size: 18),
                    ).paddingLeft(hasLeadingWidget ? 0 : 16),
                actions: actions,
                leading: leadingWidget ??
                    leadingWidget ??
                    (hasLeadingWidget
                        ? IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_outlined, color: white, size: 20),
                    )
                        : const Offstage()),
                    // (hasLeadingWidget ? backButton() : null),
              ),
            ),
      backgroundColor: scaffoldBackgroundColor ?? context.scaffoldBackgroundColor,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            body,
            Obx(
              () => (currentPage ?? (1.obs)).value == 1
                  ? const LoaderWidget().center().visible((isLoading ?? false.obs).value)
                  : Positioned(
                      bottom: 60,
                      left: 16,
                      right: 16,
                      child: const LoaderWidget(),
                    ).visible((isLoading ?? false.obs).value),
            ),
            Obx(
              () {
                if (!(isLoading ?? false.obs).value && showFloatingButton.validate() && floatingWidget != null) {
                  return Positioned(
                    left: floatingActionButtonLocation == FloatingActionButtonLocation.centerFloat ? 16 : 0,
                    right: floatingActionButtonLocation == FloatingActionButtonLocation.centerFloat ? 16 : 0,
                    bottom: floatingActionButtonLocation == FloatingActionButtonLocation.centerFloat ? 16 : 0,
                    child: floatingWidget!,
                  );
                } else {
                  return Offstage();
                }
              },
            )
          ],
        ),
      ) /*AppBody(
        isLoading: isLoading ?? false.obs,
        currentPage: currentPage ?? 1.obs,
        child: body,
      )*/
      ,
      bottomNavigationBar: bottomNavBar,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

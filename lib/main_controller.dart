import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  double height = 160;
  double maxHeight = 500;
  double width = Get.width;
  RxDouble skewX = 0.0.obs;
  RxDouble skewY = 0.0.obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.offset <= -height) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubicEmphasized,
        );
      }
      if (scrollController.position.activity is BallisticScrollActivity) {
        scrollController.animateTo(
          (scrollController.offset / 500).round() * 500,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubicEmphasized,
        );
      }
      update();
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }
}

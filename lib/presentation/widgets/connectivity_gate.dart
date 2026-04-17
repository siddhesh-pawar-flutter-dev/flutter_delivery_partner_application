import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/connectivity_controller.dart';
import '../pages/no_internet_page/no_internet_page.dart';

class ConnectivityGate extends GetView<ConnectivityController> {
  const ConnectivityGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isOnline.value ? child : const NoInternetPage(),
    );
  }
}

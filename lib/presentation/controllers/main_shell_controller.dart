import 'package:get/get.dart';

/// Controls which tab is currently active in the main shell.
class MainShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void goTo(int index) => currentIndex.value = index;
}

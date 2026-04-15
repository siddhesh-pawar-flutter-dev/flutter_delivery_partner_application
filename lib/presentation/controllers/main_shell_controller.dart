import 'package:get/get.dart';

class MainShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void goTo(int index) => currentIndex.value = index;
}

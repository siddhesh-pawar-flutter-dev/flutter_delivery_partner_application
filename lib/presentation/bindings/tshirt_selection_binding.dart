import 'package:get/get.dart';
import '../controllers/tshirt_selection_controller.dart';

class TshirtSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TshirtSelectionController>(() => TshirtSelectionController());
  }
}
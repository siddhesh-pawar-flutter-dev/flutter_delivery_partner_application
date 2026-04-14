import 'package:get/get.dart';

import '../../domain/usecases/get_order_history_usecase.dart';
import '../controllers/order_history_controller.dart';

class OrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => OrderHistoryController(
        getOrdersUseCase: Get.find<GetOrderHistoryUseCase>(),
      ),
      fenix: true,
    );
  }
}

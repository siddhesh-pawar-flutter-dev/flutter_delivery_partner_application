import 'package:get/get.dart';

import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_saved_user_usecase.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        getOrdersUseCase: Get.find<GetOrderHistoryUseCase>(),
        getProfileUseCase: Get.find<GetProfileUseCase>(),
        getSavedUserUseCase: Get.find<GetSavedUserUseCase>(),
      ),
      fenix: true,
    );
  }
}

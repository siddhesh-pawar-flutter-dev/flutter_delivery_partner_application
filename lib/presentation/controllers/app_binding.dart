import 'package:get/get.dart';

import '../../core/network/network_info.dart';
import '../../domain/usecases/get_saved_language_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../controllers/splash_controller.dart';
import 'connectivity_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      SplashController(
        isLoggedInUseCase: Get.find<IsLoggedInUseCase>(),
        getSavedLanguageUseCase: Get.find<GetSavedLanguageUseCase>(),
      ),
      permanent: true,
    );

    Get.lazyPut(
      () => ConnectivityController(networkInfo: Get.find<NetworkInfo>()),
      fenix: true,
    );
  }
}

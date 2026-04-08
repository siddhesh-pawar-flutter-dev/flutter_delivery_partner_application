import 'package:get/get.dart';

import '../../domain/usecases/get_profile_usecase.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProfileController(
        getProfileUseCase: Get.find<GetProfileUseCase>(),
      ),
      fenix: true,
    );
  }
}

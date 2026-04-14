import 'package:get/get.dart';

import '../../core/utils/storage_service.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProfileController(
        getProfileUseCase: Get.find<GetProfileUseCase>(),
        storageService: Get.find<StorageService>(),
      ),
      fenix: true,
    );
  }
}

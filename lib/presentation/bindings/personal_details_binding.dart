import 'package:get/get.dart';
import '../controllers/personal_details_controller.dart';
import '../../domain/usecases/get_profile_usecase.dart';

class PersonalDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalDetailsController(
          getProfileUseCase: Get.find<GetProfileUseCase>(),
        ));
  }
}

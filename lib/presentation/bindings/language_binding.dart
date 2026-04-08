import 'package:get/get.dart';

import '../../domain/usecases/get_saved_language_usecase.dart';
import '../../domain/usecases/save_language_usecase.dart';
import '../controllers/language_controller.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => LanguageController(
        saveLanguageUseCase: Get.find<SaveLanguageUseCase>(),
        getSavedLanguageUseCase: Get.find<GetSavedLanguageUseCase>(),
      ),
      fenix: true,
    );
  }
}

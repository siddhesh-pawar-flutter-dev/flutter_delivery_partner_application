import 'package:get/get.dart';

import '../../core/utils/app_pages.dart';
import '../../domain/usecases/get_saved_language_usecase.dart';
import '../../domain/usecases/save_language_usecase.dart';

class LanguageController extends GetxController {
  LanguageController({
    required SaveLanguageUseCase saveLanguageUseCase,
    required GetSavedLanguageUseCase getSavedLanguageUseCase,
  }) : _saveLanguageUseCase = saveLanguageUseCase,
       _getSavedLanguageUseCase = getSavedLanguageUseCase;

  final SaveLanguageUseCase _saveLanguageUseCase;
  final GetSavedLanguageUseCase _getSavedLanguageUseCase;

  final RxString selectedLanguage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = _getSavedLanguageUseCase();
  }

  Future<void> proceed() async {
    if (selectedLanguage.value.isEmpty) return;
    await _saveLanguageUseCase(selectedLanguage.value);
    Get.offAllNamed(AppPages.login);
  }
}

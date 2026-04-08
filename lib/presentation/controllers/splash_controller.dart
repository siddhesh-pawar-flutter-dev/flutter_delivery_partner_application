import 'package:get/get.dart';

import '../../core/utils/app_pages.dart';
import '../../domain/usecases/get_saved_language_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';

class SplashController extends GetxController {
  SplashController({
    required IsLoggedInUseCase isLoggedInUseCase,
    required GetSavedLanguageUseCase getSavedLanguageUseCase,
  }) : _isLoggedInUseCase = isLoggedInUseCase,
       _getSavedLanguageUseCase = getSavedLanguageUseCase;

  final IsLoggedInUseCase _isLoggedInUseCase;
  final GetSavedLanguageUseCase _getSavedLanguageUseCase;

  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    final hasLanguage = _getSavedLanguageUseCase().isNotEmpty;
    final nextRoute =
        _isLoggedInUseCase()
            ? AppPages.home
            : hasLanguage
                ? AppPages.login
                : AppPages.language;
    Get.offAllNamed(nextRoute);
  }
}

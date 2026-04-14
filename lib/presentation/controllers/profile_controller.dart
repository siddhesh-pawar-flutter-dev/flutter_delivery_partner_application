import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/error/failures.dart';
import '../../core/utils/app_pages.dart';
import '../../core/utils/storage_service.dart';
import '../../domain/entities/profile_details.dart';
import '../../domain/usecases/get_profile_usecase.dart';

class ProfileController extends GetxController {
  ProfileController({
    required GetProfileUseCase getProfileUseCase,
    required StorageService storageService,
  }) : _getProfileUseCase = getProfileUseCase,
       _storageService = storageService;

  final GetProfileUseCase _getProfileUseCase;
  final StorageService _storageService;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString appVersion = ''.obs;
  final Rxn<ProfileDetails> profile = Rxn<ProfileDetails>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadAppVersion();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      profile.value = await _getProfileUseCase();
    } on Failure catch (error) {
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion.value =
        'App Version ${packageInfo.version} (${packageInfo.buildNumber})';
  }

  Future<void> logout() async {
    await _storageService.clearSession();
    Get.offAllNamed(AppPages.login);
  }
}

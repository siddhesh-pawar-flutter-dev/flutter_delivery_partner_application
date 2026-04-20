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

  // Kinetic Logistics Specifics
  final RxInt complianceScore = 0.obs;
  final RxBool isOnline = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadAppVersion();
  }
  String lastFour(String acc) {
    if (acc.length < 4) return acc;
    return acc.substring(acc.length - 4);
  }
  Future<void> loadProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await _getProfileUseCase();
      profile.value = data;
      _calculateCompliance(data);
      isOnline.value = data.deliveryPartner.canOnline;
    } on Failure catch (error) {
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateCompliance(ProfileDetails p) {
    int filled = 0;
    final partner = p.deliveryPartner;
    final vehicle = p.vehicleDetails;
    final bank = p.bankDetails;

    if (partner.name.isNotEmpty) filled++;
    if (partner.email.isNotEmpty) filled++;
    if (partner.phoneNumber.isNotEmpty) filled++;
    if (partner.profileImage.isNotEmpty) filled++;
    if (partner.city.isNotEmpty) filled++;
    
    if (vehicle.vehicleType.isNotEmpty) filled++;
    if (vehicle.vehicleNumber.isNotEmpty) filled++;
    
    if (bank.bankName.isNotEmpty) filled++;
    if (bank.accountNumber.isNotEmpty) filled++;
    if (bank.ifscCode.isNotEmpty) filled++;
    if (bank.accountType.isNotEmpty) filled++;

    if (p.documents.isNotEmpty) filled++;

    complianceScore.value = ((filled / 12) * 100).round();
  }

  void toggleOnline() {
    isOnline.value = !isOnline.value;
    // In search of "essence", we'll implement the UI change optimistically.
    // If there was an API for this, we'd call it here.
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

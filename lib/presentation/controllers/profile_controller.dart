import 'package:get/get.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/profile_details.dart';
import '../../domain/usecases/get_profile_usecase.dart';

class ProfileController extends GetxController {
  ProfileController({
    required GetProfileUseCase getProfileUseCase,
  }) : _getProfileUseCase = getProfileUseCase;

  final GetProfileUseCase _getProfileUseCase;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<ProfileDetails> profile = Rxn<ProfileDetails>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
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
}

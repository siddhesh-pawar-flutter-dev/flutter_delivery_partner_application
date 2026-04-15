import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/profile_details.dart';
import '../../domain/usecases/get_profile_usecase.dart';

class PersonalDetailsController extends GetxController {
  PersonalDetailsController({
    required GetProfileUseCase getProfileUseCase,
  }) : _getProfileUseCase = getProfileUseCase;

  final GetProfileUseCase _getProfileUseCase;

  final RxBool isLoading = false.obs;
  final Rxn<ProfileDetails> profile = Rxn<ProfileDetails>();
  final RxString errorMessage = ''.obs;

  // Form Field Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final zipController = TextEditingController();
  final addressController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    zipController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await _getProfileUseCase();
      profile.value = data;
      _initializeControllers(data);
    } on Failure catch (error) {
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
    }
  }

  void _initializeControllers(ProfileDetails p) {
    nameController.text = p.deliveryPartner.name;
    emailController.text = p.deliveryPartner.email;
    phoneController.text = p.deliveryPartner.phoneNumber;
    // Mocking Zip and DOB as they might not be in the base entity yet
    dobController.text = '05/14/1992'; 
    zipController.text = '11201';
    addressController.text = p.deliveryPartner.city; // Using city as placeholder
  }

  Future<void> saveChanges() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Update local state (optimistic)
      if (profile.value != null) {
        final updatedPartner = profile.value!.deliveryPartner.copyWith(
          name: nameController.text,
          email: emailController.text,
          phoneNumber: phoneController.text,
        );
        profile.value = ProfileDetails(
          deliveryPartner: updatedPartner,
          vehicleDetails: profile.value!.vehicleDetails,
          bankDetails: profile.value!.bankDetails,
          documents: profile.value!.documents,
        );
      }
      
      Get.back(); // Return to summary page
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF263238),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  // Validators
  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your name';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!GetUtils.isEmail(value)) return 'Please enter a valid email address';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your phone number';
    if (!GetUtils.isPhoneNumber(value)) return 'Please enter a valid phone number';
    return null;
  }
}

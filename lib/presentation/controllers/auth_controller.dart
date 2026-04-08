import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/error/failures.dart';
import '../../core/utils/app_pages.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

class AuthController extends GetxController {
  AuthController({
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  }) : _sendOtpUseCase = sendOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase;

  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  final RxBool isSendingOtp = false.obs;
  final RxBool isVerifyingOtp = false.obs;
  final RxInt secondsLeft = 30.obs;
  final RxString currentPhone = ''.obs;

  Timer? _timer;

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();
    if (phone.length != 10) {
      Get.snackbar('Invalid number', 'Please enter a valid 10-digit number.');
      return;
    }

    isSendingOtp.value = true;
    try {
      await _sendOtpUseCase(countryCode: '+91', phone: phone);
      currentPhone.value = phone;
      _startTimer();
      Get.toNamed(AppPages.otp);
      Get.snackbar('OTP sent', 'Use 111111 for testing if enabled.');
    } on Failure catch (error) {
      Get.snackbar('Unable to send OTP', error.message);
    } finally {
      isSendingOtp.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (secondsLeft.value > 0 || currentPhone.value.isEmpty) return;
    await _sendOtpUseCase(countryCode: '+91', phone: currentPhone.value);
    _startTimer();
    Get.snackbar('OTP resent', 'A new OTP has been sent to your mobile.');
  }

  Future<void> verifyOtp() async {
    final otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length != 6) {
      Get.snackbar('Invalid OTP', 'Please enter the 6-digit OTP.');
      return;
    }

    isVerifyingOtp.value = true;
    try {
      await _verifyOtpUseCase(
        otp: otp,
        countryCode: '+91',
        phone: currentPhone.value,
      );
      Get.offAllNamed(AppPages.home);
    } on Failure catch (error) {
      Get.snackbar('Verification failed', error.message);
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  void onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < otpFocusNodes.length - 1) {
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    secondsLeft.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft.value == 0) {
        timer.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  @override
  void onClose() {
    phoneController.dispose();
    for (final controller in otpControllers) {
      controller.dispose();
    }
    for (final focusNode in otpFocusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.onClose();
  }
}

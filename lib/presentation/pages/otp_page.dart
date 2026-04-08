import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/connectivity_gate.dart';
import '../widgets/primary_button.dart';

class OtpPage extends GetView<AuthController> {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return ConnectivityGate(
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify OTP',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Text(
                    'Enter the code sent to +91 ${controller.currentPhone.value}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: List.generate(6, (index) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 5 ? 0 : 8),
                        child: TextField(
                          controller: controller.otpControllers[index],
                          focusNode: controller.otpFocusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          onChanged: (value) => controller.onOtpChanged(index, value),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18),
                Obx(
                  () => Row(
                    children: [
                      Text(
                        controller.secondsLeft.value == 0
                            ? 'Didn\'t receive OTP?'
                            : 'Resend in ${controller.secondsLeft.value}s',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed:
                            controller.secondsLeft.value == 0
                                ? controller.resendOtp
                                : null,
                        child: const Text('Resend'),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Obx(
                  () => PrimaryButton(
                    label: 'Verify & Continue',
                    isLoading: controller.isVerifyingOtp.value,
                    onPressed: controller.verifyOtp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/connectivity_gate.dart';

class OtpPage extends GetView<AuthController> {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AuthController>();

    return ConnectivityGate(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5FAF2),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Gradient wave header (matches login page) ──────────────
              ClipPath(
                clipper: _WaveClipper(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFAAF0B7), Color(0xFF4CAF50)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative sparkle dots
                      const Positioned(
                        top: 18,
                        left: 26,
                        child: _SparkleDot(size: 6),
                      ),
                      const Positioned(
                        top: 54,
                        right: 34,
                        child: _SparkleDot(size: 7),
                      ),
                      const Positioned(
                        top: 96,
                        left: 98,
                        child: _SparkleDot(size: 5),
                      ),
                      const Positioned(
                        top: 164,
                        right: 18,
                        child: _SparkleDot(size: 6),
                      ),
                      // Decorative translucent circles
                      Positioned(
                        top: -50,
                        right: -56,
                        child: Container(
                          width: 172,
                          height: 172,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -70,
                        bottom: 48,
                        child: Container(
                          width: 152,
                          height: 152,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Back button
                      Positioned(
                        top: 12,
                        left: 0,
                        child: GestureDetector(
                          onTap: () => Get.back<void>(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      // Hero content
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 42),
                              child: _OtpHeroIcon(),
                            ),
                          ),
                          Text(
                            'Almost there!',
                            style: TextStyle(
                              color: Color(0xFF204B27),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Verify your\nmobile number',
                            style: TextStyle(
                              color: Color(0xFF132A18),
                              fontSize: 24,
                              height: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 56),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── White bottom panel (form area) ─────────────────────────
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 36, 20, 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight - 18,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Sub-heading
                                  const Text(
                                    'Enter OTP',
                                    style: TextStyle(
                                      color: Color(0xFF525A61),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Obx(
                                    () => Text(
                                      'Code sent to +91 ${ctrl.currentPhone.value}',
                                      style: const TextStyle(
                                        color: Color(0xFF9AA0A6),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // OTP input boxes
                                  Row(
                                    children: List.generate(6, (index) {
                                      return Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right: index == 6 ? 0 : 2,
                                          ),
                                          child: Container(
                                            height: 54,
                                            width: 54,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF5F6F7),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: const Color(0xFFE4E8EA),
                                              ),
                                            ),
                                            child: TextField(
                                              controller:
                                                  ctrl.otpControllers[index],
                                              focusNode:
                                                  ctrl.otpFocusNodes[index],
                                              textAlign: TextAlign.center,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: const TextStyle(
                                                color: Color(0xFF9AA0A6),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                  1,
                                                ),
                                              ],
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                counterText: '',
                                                contentPadding: EdgeInsets.all(
                                                  12,
                                                ),
                                              ),
                                              onChanged: (value) => ctrl
                                                  .onOtpChanged(index, value),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),

                                  const SizedBox(height: 20),

                                  // Resend row
                                  Obx(
                                    () => Row(
                                      children: [
                                        Text(
                                          ctrl.secondsLeft.value == 0
                                              ? "Didn't receive OTP?"
                                              : 'Resend in ${ctrl.secondsLeft.value}s',
                                          style: const TextStyle(
                                            color: Color(0xFF6E737B),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: ctrl.secondsLeft.value == 0
                                              ? ctrl.resendOtp
                                              : null,
                                          style: TextButton.styleFrom(
                                            foregroundColor: const Color(
                                              0xFF3BAA45,
                                            ),
                                          ),
                                          child: const Text(
                                            'Resend',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Spacer(),

                                  // Verify button
                                  Obx(
                                    () => SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF34B449,
                                          ),
                                          foregroundColor: Colors.white,
                                          disabledBackgroundColor: const Color(
                                            0xFF34B449,
                                          ).withValues(alpha: 0.45),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        onPressed: ctrl.isVerifyingOtp.value
                                            ? null
                                            : ctrl.verifyOtp,
                                        child: ctrl.isVerifyingOtp.value
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.4,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                              )
                                            : const Text(
                                                'Verify & Continue',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OTP hero icon (lock with digits feel)
// ─────────────────────────────────────────────────────────────────────────────

class _OtpHeroIcon extends StatelessWidget {
  const _OtpHeroIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      height: 108,
      decoration: BoxDecoration(
        color: const Color(0xFFF4FFF1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x160C4B1B),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.lock_rounded, size: 54, color: Color(0xFF2D8E3A)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared wave + sparkle decorations (same as login_page.dart)
// ─────────────────────────────────────────────────────────────────────────────

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 30,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 60,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper old) => false;
}

class _SparkleDot extends StatelessWidget {
  const _SparkleDot({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

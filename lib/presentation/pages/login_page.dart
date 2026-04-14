import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/connectivity_gate.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return ConnectivityGate(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5FAF2),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 42.0),
                              child: _HeroIcon(),
                            ),
                          ),

                          Text(
                            'Be an Easy Cater Partner',
                            style: TextStyle(
                              color: Color(0xFF204B27),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Get a stable monthly\nincome',
                            style: TextStyle(
                              color: Color(0xFF132A18),
                              fontSize: 24,
                              height: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: _IndiaBadge(),
                          ),
                          SizedBox(height: 40.0),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ClipPath(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 42, 20, 24),
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
                                    const Text(
                                      'Enter Mobile Number',
                                      style: TextStyle(
                                        color: Color(0xFF525A61),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F6F7),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: const Color(0xFFE4E8EA),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: controller.phoneController,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        style: const TextStyle(
                                          color: Color(0xFF9AA0A6),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration: const InputDecoration(
                                          counterText: '',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 18,
                                          ),
                                          prefixIconConstraints: BoxConstraints(
                                            minWidth: 0,
                                            minHeight: 0,
                                          ),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(
                                              left: 16,
                                              right: 12,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '🇮🇳',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  '+91',
                                                  style: TextStyle(
                                                    color: Color(0xFF9AA0A6),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                SizedBox(
                                                  height: 22,
                                                  child: VerticalDivider(
                                                    thickness: 1,
                                                    color: Color(0xFFE3E5E8),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                              ],
                                            ),
                                          ),
                                          hintText: 'Mobile Number',
                                          hintStyle: TextStyle(
                                            color: Color(0xFFB1B7BF),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    Obx(
                                      () => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Transform.translate(
                                            offset: const Offset(-10, -2),
                                            child: Checkbox(
                                              value: controller
                                                  .hasAcceptedTerms
                                                  .value,
                                              onChanged: controller.toggleTerms,
                                              checkColor: Colors.white,
                                              activeColor: const Color(
                                                0xFF2E7D32,
                                              ),
                                              side: const BorderSide(
                                                color: Color(0xFF7D7F87),
                                              ),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity:
                                                  const VisualDensity(
                                                    horizontal: -4,
                                                    vertical: -4,
                                                  ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                              ),
                                              child: RichText(
                                                text: const TextSpan(
                                                  style: TextStyle(
                                                    color: Color(0xFF6E737B),
                                                    fontSize: 14,
                                                    height: 1.45,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'By signing up I agree to the ',
                                                    ),
                                                    TextSpan(
                                                      text: 'Terms of use',
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFF3BAA45,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    TextSpan(text: ' and '),
                                                    TextSpan(
                                                      text: 'Privacy Policy.',
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFF3BAA45,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
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
                                            disabledBackgroundColor:
                                                const Color(
                                                  0xFF34B449,
                                                ).withValues(alpha: 0.45),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          onPressed:
                                              controller.isSendingOtp.value
                                              ? null
                                              : controller.sendOtp,
                                          child: controller.isSendingOtp.value
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
                                                  'Send OTP',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon();

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
        child: Icon(
          Icons.delivery_dining_rounded,
          size: 58,
          color: Color(0xFF2D8E3A),
        ),
      ),
    );
  }
}

class _IndiaBadge extends StatelessWidget {
  const _IndiaBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🇮🇳', style: TextStyle(fontSize: 18)),
          SizedBox(width: 8),
          Text(
            'India Delivery Partner',
            style: TextStyle(
              color: Color(0xFF1D4D29),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height, // left control point — pulls up
      size.width * 0.5,
      size.height - 30, // center dips back down
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 60, // right control point
      size.width,
      size.height - 20, // ends lower on the right
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

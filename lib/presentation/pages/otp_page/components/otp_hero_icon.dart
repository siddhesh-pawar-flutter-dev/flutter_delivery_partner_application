import 'package:flutter/material.dart';

class OtpHeroIcon extends StatelessWidget {
  const OtpHeroIcon({super.key});

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
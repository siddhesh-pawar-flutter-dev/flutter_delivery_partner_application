import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToggleHalfIndicator extends StatelessWidget {
  const ToggleHalfIndicator({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: isActive
                  ? (label == 'Online' ? Colors.white : const Color(0xFF263238))
                  : const Color(0xFF8D8D8D),
            ),
          ),
        ),
      ),
    );
  }
}

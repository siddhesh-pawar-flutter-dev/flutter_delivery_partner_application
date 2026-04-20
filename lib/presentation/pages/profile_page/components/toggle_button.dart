import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? activeColor : colorScheme.onSurfaceVariant,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

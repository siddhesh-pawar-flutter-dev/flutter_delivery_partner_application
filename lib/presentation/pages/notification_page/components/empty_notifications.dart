import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: Color(0xFFE3F0F8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                size: 48,
                color: Color(0xFF707A6C),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'All Caught Up!',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111D23),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We'll notify you when something important happens.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF40493D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

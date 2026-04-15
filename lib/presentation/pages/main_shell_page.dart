import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_shell_controller.dart';
import '../pages/home_page.dart';
import '../pages/order_history_page.dart';
import '../pages/profile_page.dart';

class MainShellPage extends GetView<MainShellController> {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps all three pages alive in memory so their
      // controllers/scroll positions are preserved when switching tabs.
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [HomePage(), OrderHistoryPage(), ProfilePage()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => _SharedBottomBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.goTo,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared Bottom Bar
// ─────────────────────────────────────────────────────────────────────────────

class _SharedBottomBar extends StatelessWidget {
  const _SharedBottomBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final void Function(int) onTap;

  static const _items = [
    _NavItem(icon: Icons.home_filled, label: 'Home'),
    _NavItem(icon: Icons.receipt_long_outlined, label: 'Orders'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 24,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < _items.length; i++)
              GestureDetector(
                onTap: () => onTap(i),
                child: _BottomItem(
                  icon: _items[i].icon,
                  label: _items[i].label,
                  isSelected: currentIndex == i,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  final IconData icon;
  final String label;
  final bool isSelected;

  static const _gradientColors = [Color(0xFFAAF0B7), Color(0xFF4CAF50)];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: _gradientColors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: isSelected
              ? ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Colors.white],
                  ).createShader(bounds),
                  child: Icon(icon, size: 24, color: Colors.white),
                )
              : Icon(icon, size: 24, color: const Color(0xFF8E8E8E)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF2E7D32)
                : const Color(0xFF8E8E8E),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

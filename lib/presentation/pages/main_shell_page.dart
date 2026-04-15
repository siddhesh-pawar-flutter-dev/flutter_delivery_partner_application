import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_shell_controller.dart';
import '../pages/gig_history_page.dart';
import '../pages/home_page.dart';
import '../pages/order_history_page.dart';
import '../pages/payout_history_page.dart';
import '../pages/profile_page.dart';

class MainShellPage extends GetView<MainShellController> {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allow body to flow behind the dock
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomePage(),
            OrderHistoryPage(),
            GigHistoryPage(),
            PayoutHistoryPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => _TheDock(
          currentIndex: controller.currentIndex.value,
          onTap: controller.goTo,
        ),
      ),
    );
  }
}

class _TheDock extends StatelessWidget {
  const _TheDock({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final void Function(int) onTap;

  static const _items = [
    _NavItem(icon: Icons.grid_view_rounded, label: 'Hub'),
    _NavItem(icon: Icons.local_shipping_rounded, label: 'Deliveries'),
    _NavItem(icon: Icons.payments_rounded, label: 'Earnings'),
    _NavItem(icon: Icons.account_balance_wallet_rounded, label: 'Wallet'),
    _NavItem(icon: Icons.account_circle_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16), // Floating 16pt (8pt in design system + extra padding)
      height: 72,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < _items.length; i++)
                  _DockItem(
                    icon: _items[i].icon,
                    label: _items[i].label,
                    isSelected: currentIndex == i,
                    onTap: () => onTap(i),
                  ),
              ],
            ),
          ),
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

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

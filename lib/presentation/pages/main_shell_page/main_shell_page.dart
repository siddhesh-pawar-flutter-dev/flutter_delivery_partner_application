import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/main_shell_controller.dart';
import '../gig_history_page/gig_history_page.dart';
import '../home_page/home_page.dart';
import '../order_history_page/order_history_page.dart';
import '../payout_history_page/payout_history_page.dart';
import '../profile_page/profile_page.dart';

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
    _NavItem(icon: Icons.delivery_dining_rounded, label: 'Deliveries'),
    _NavItem(icon: Icons.payments_rounded, label: 'Earnings'),
    _NavItem(icon: Icons.account_balance_wallet_rounded, label: 'Wallet'),
    _NavItem(icon: Icons.account_circle_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inactiveColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.68);

    const bubbleSize = 50.0;
    const dockTopInset = 24.0;
    const dockHeight = 78.0;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: SizedBox(
          height: dockHeight + dockTopInset,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const dockHorizontalPadding = 8.0;
              final itemWidth =
                  (constraints.maxWidth - dockHorizontalPadding * 2) /
                  _items.length;
              final bubbleLeft =
                  dockHorizontalPadding +
                  (itemWidth * currentIndex) +
                  ((itemWidth - bubbleSize) / 2);

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: dockTopInset,
                    bottom: 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.12,
                            ),
                            blurRadius: 30,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLowest
                                  .withValues(alpha: 0.86),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.82),
                              ),
                            ),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 320),
                                  curve: Curves.easeOut,
                                  left: bubbleLeft,
                                  top:
                                      15, // increase this value to pull it further down
                                  width: bubbleSize,
                                  height: bubbleSize,
                                  child: IgnorePointer(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorScheme.surface,
                                        border: Border.all(
                                          color: colorScheme.surface.withValues(
                                            alpha: 0.96,
                                          ),
                                          width: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    8,
                                    12,
                                    8,
                                    8,
                                  ),
                                  child: Row(
                                    children: [
                                      for (int i = 0; i < _items.length; i++)
                                        _DockItem(
                                          icon: _items[i].icon,
                                          label: _items[i].label,
                                          isSelected: currentIndex == i,
                                          activeColor: colorScheme.primary,
                                          inactiveColor: inactiveColor,
                                          onTap: () => onTap(i),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOut,
                    left: bubbleLeft,
                    top: 16,
                    width: bubbleSize,
                    height: bubbleSize,
                    child: _ActiveDockOrb(
                      item: _items[currentIndex],
                      onTap: () => onTap(currentIndex),
                    ),
                  ),
                ],
              );
            },
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
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 24,
                  child: Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      opacity: isSelected ? 0 : 1,
                      child: Icon(icon, size: 21, color: inactiveColor),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  offset: Offset(0, isSelected ? -0.14 : 0),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: isSelected ? activeColor : inactiveColor,
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
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

class _ActiveDockOrb extends StatelessWidget {
  const _ActiveDockOrb({required this.item, required this.onTap});

  final _NavItem item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary, colorScheme.primaryContainer],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.95),
            width: 3, // reduced from 4
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(
                  10,
                ), // controls tap area & icon breathing room
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: Icon(
                    item.icon,
                    key: ValueKey(item.label),
                    size: 20, // reduced from 22
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

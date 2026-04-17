import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/entities/delivery_partner.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/main_shell_controller.dart';
import '../../widgets/active_order_section.dart';
import '../../widgets/connectivity_gate.dart';
import '../../widgets/order_card.dart';
import '../../widgets/tshirt_card.dart';
import '../notification_page/notification_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConnectivityGate(
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Obx(() {
            final user = controller.user.value;
            final displayedOrders = controller.todayOrders.isNotEmpty
                ? controller.todayOrders
                : controller.orders;

            return RefreshIndicator(
              color: colorScheme.primary,
              onRefresh: controller.refreshOrders,
              child: ListView(
                controller: controller.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                children: [
                  _TopBar(user: user),
                  const SizedBox(height: 32),
                  const _GreetingSection(),
                  const SizedBox(height: 16),
                  const _AvailabilityToggle(),
                  const SizedBox(height: 32),

                  if (controller.shouldShowTshirtCard)
                    const Column(
                      children: [TshirtCard(), SizedBox(height: 32)],
                    ),

                  _SectionHeader(
                    title: 'Active Deliveries',
                    icon: Icons.restaurant_rounded,
                    count: controller.todayActiveCount,
                  ),
                  const SizedBox(height: 16),
                  if (controller.activeOrder != null)
                    ActiveOrderSection(order: controller.activeOrder!)
                  else
                    const _EmptyDeliveriesIndicator(),

                  const SizedBox(height: 32),
                  const _WeeklyEarningsCard(),
                  const SizedBox(height: 32),

                  const _SectionHeader(title: 'Overview'),
                  const SizedBox(height: 16),
                  const _StatisticsGrid(),
                  const SizedBox(height: 32),

                  _DeliveryListHeader(count: displayedOrders.length),
                  const SizedBox(height: 16),
                  if (controller.isLoading.value && controller.orders.isEmpty)
                    const _OrderSkeletonList()
                  else if (displayedOrders.isEmpty)
                    const _EmptyState(message: 'No completed deliveries yet.')
                  else ...[
                    ListView.builder(
                      itemCount: displayedOrders.length > 5
                          ? 5
                          : displayedOrders.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return OrderCard(order: displayedOrders[index]);
                      },
                    ),
                    if (displayedOrders.length > 5) ...[
                      const SizedBox(height: 12),
                      _ViewMoreButton(
                        onTap: () => Get.find<MainShellController>().goTo(1),
                      ),
                    ],
                  ],

                  // Bottom spacing for the floating dock
                  const SizedBox(height: 80),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.user});
  final DeliveryPartner? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        // 1. Avatar with aura ring
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: _ProfileAvatar(user: user),
        ),
        const SizedBox(width: 12),
        // 2. Info section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Easy Cater',
                style: GoogleFonts.manrope(
                  color: colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    size: 14,
                    color: colorScheme.tertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '4.9 Star Rating',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // 3. Aura Notification Button
        _AuraNotificationButton(
          onTap: () => Get.to(() => const NotificationPage()),
        ),
      ],
    );
  }
}

class _GreetingSection extends GetView<HomeController> {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready for lunch rush?',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Obx(
          () => Text(
            'Hi, ${controller.greetingName}',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _AvailabilityToggle extends GetView<HomeController> {
  const _AvailabilityToggle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final isOnline = controller.canReceiveOrders;
      return Container(
        height: 52,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutBack,
              alignment: isOnline
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isOnline
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: isOnline
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                _ToggleHalfIndicator(
                  label: 'Online',
                  isActive: isOnline,
                  onTap: () => controller.toggleOnlineStatus(true),
                ),
                _ToggleHalfIndicator(
                  label: 'Offline',
                  isActive: !isOnline,
                  onTap: () => controller.toggleOnlineStatus(false),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _ToggleHalfIndicator extends StatelessWidget {
  const _ToggleHalfIndicator({
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

class _WeeklyEarningsCard extends GetView<HomeController> {
  const _WeeklyEarningsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEEKLY EARNINGS',
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Obx(
                () => Text(
                  _currency(controller.weeklyEarnings),
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '+12%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // No-line Divider substitute (empty space)
          const SizedBox(height: 1),
          Row(
            children: [
              Expanded(
                child: _EarningStat(label: 'TIPS INCLUDED', value: '₹342.00'),
              ),
              Container(
                width: 1,
                height: 32,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              Expanded(
                child: _EarningStat(
                  label: 'NET BALANCE',
                  value: _currency(controller.weeklyEarnings - 342),
                  isRight: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _WithdrawButton(onTap: () {}),
        ],
      ),
    );
  }
}

class _StatisticsGrid extends GetView<HomeController> {
  const _StatisticsGrid();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,

        children: [
          _StatusTile(
            icon: Icons.lunch_dining_rounded,
            label: 'Deliveries Done',
            value: '${controller.todayCompletedCount}',
            color: const Color(0xFF7c5c46),
            backgroundColor: const Color(0xFFfdecdb),
          ),
          _StatusTile(
            icon: Icons.shopping_bag_rounded,
            label: 'Available Deliveries',
            value: '08',
            color: const Color(0xFF2E7D32),
            backgroundColor: const Color(0xFFccf5cc),
          ),
          _StatusTile(
            icon: Icons.local_offer_rounded,
            label: 'New Offers',
            value: '12',
            badgeText: '+2 New',
            color: const Color(0xFFd9435e),
            backgroundColor: const Color(0xFFffd9e2),
          ),
          _StatusTile(
            icon: Icons.timeline_rounded,
            label: 'Total Career',
            value: '1,482',
            unit: 'DELIVERIES',
            color: const Color(0xFF455A64),
            backgroundColor: const Color(0xFFCFE6F2),
          ),
        ],
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.backgroundColor,
    this.badgeText,
    this.unit,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color backgroundColor;
  final String? badgeText;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScaleInteraction(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const Spacer(),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (badgeText != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    badgeText!,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.icon, this.count});
  final String title;
  final IconData? icon;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: colorScheme.primary, size: 18, weight: 800),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        if (count != null)
          Text(
            '$count order${count == 1 ? "" : "s"}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _DeliveryListHeader extends StatelessWidget {
  const _DeliveryListHeader({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Today's Deliveries",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          "$count orders",
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EarningStat extends StatelessWidget {
  const _EarningStat({
    required this.label,
    required this.value,
    this.isRight = false,
  });
  final String label;
  final String value;
  final bool isRight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: isRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _AuraNotificationButton extends StatelessWidget {
  const _AuraNotificationButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          Icons.notifications_none_rounded,
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }
}

class _WithdrawButton extends StatelessWidget {
  const _WithdrawButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScaleInteraction(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(99),
        ),
        child: const Center(
          child: Text(
            'Withdraw',
            style: TextStyle(
              color: Color(0xFF2d8a39),
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewMoreButton extends StatelessWidget {
  const _ViewMoreButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScaleInteraction(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF2d8a39),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'View More',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});
  final DeliveryPartner? user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageUrl = user?.profileImage ?? '';
    final initials = _initials(user?.name);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary,
      ),
      child: ClipOval(
        child: imageUrl.isEmpty
            ? Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _EmptyDeliveriesIndicator extends StatelessWidget {
  const _EmptyDeliveriesIndicator();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.delivery_dining_rounded,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'No active deliveries',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSkeletonList extends StatelessWidget {
  const _OrderSkeletonList();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (i) => Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.grey)),
    );
  }
}

String _currency(double value) {
  final hasDecimals = value.truncateToDouble() != value;
  return 'Rs ${value.toStringAsFixed(hasDecimals ? 2 : 0)}';
}

String _initials(String? name) {
  final trimmed = name?.trim() ?? '';
  if (trimmed.isEmpty) return 'DP';
  final parts = trimmed.split(RegExp(r'\s+'));
  return (parts.first[0] + (parts.length > 1 ? parts[1][0] : '')).toUpperCase();
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/delivery_partner.dart';
import '../controllers/home_controller.dart';
import '../controllers/main_shell_controller.dart';
import '../widgets/active_order_section.dart';
import '../widgets/connectivity_gate.dart';
import '../widgets/order_card.dart';
import '../widgets/tshirt_card.dart';
import 'notification_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityGate(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F5F2),
        body: SafeArea(
          child: Obx(() {
            final user = controller.user.value;
            final displayedOrders = controller.todayOrders.isNotEmpty
                ? controller.todayOrders
                : controller.orders;

            return RefreshIndicator(
              color: const Color(0xFF4CAF50),
              onRefresh: controller.refreshOrders,
              child: ListView(
                controller: controller.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                cacheExtent: 1400,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _TopBar(user: user),
                  const SizedBox(height: 18),
                  _AvailabilityCard(
                    isOnline: controller.canReceiveOrders,
                    canToggle: user?.termToggle ?? false,
                  ),
                  const SizedBox(height: 18),
                  if (controller.shouldShowTshirtCard)
                    Column(
                      children: [
                        const TshirtCard(),
                        const SizedBox(height: 18),
                      ],
                    ),
                  const _SectionTitle("Today's Summary"),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.48,
                    children: [
                      _SummaryTile(
                        icon: Icons.account_balance_wallet_rounded,
                        iconColor: const Color(0xFF2F9D57),
                        iconBackground: const Color(0xFFE7F5EA),
                        value: _currency(controller.todayEarnings),
                        label: 'Earnings',
                        subtitle: 'Today',
                      ),
                      _SummaryTile(
                        icon: Icons.check_circle_rounded,
                        iconColor: const Color(0xFF2E7AD7),
                        iconBackground: const Color(0xFFE8F1FD),
                        value: '${controller.todayCompletedCount}',
                        label: 'Orders Done',
                        subtitle: 'Today',
                      ),
                      _SummaryTile(
                        icon: Icons.pending_actions_rounded,
                        iconColor: const Color(0xFFF3A519),
                        iconBackground: const Color(0xFFFFF5DE),
                        value: '${controller.todayActiveCount}',
                        label: 'Pending',
                        subtitle: 'Today',
                      ),
                      _SummaryTile(
                        icon: Icons.list_alt_rounded,
                        iconColor: const Color(0xFFE56A6E),
                        iconBackground: const Color(0xFFFFECEC),
                        value: '${controller.todayTotalCount}',
                        label: 'Total Orders',
                        subtitle: 'Today',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InfoBanner(isOnline: controller.canReceiveOrders),
                  const SizedBox(height: 18),
                  if (controller.activeOrder != null)
                    Column(
                      children: [
                        ActiveOrderSection(order: controller.activeOrder!),
                        const SizedBox(height: 24),
                      ],
                    ),
                  _DeliveryHeader("Today's Deliveries", displayedOrders.length),
                  const SizedBox(height: 12),
                  if (controller.isLoading.value && controller.orders.isEmpty)
                    const _OrderSkeletonList()
                  else if (displayedOrders.isEmpty)
                    const _EmptyDeliveries()
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
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.find<MainShellController>().goTo(1);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A2633),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text(
                                  'View More',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                  if (controller.isLoadingMore.value)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (controller.errorMessage.value.isNotEmpty &&
                      controller.orders.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          color: Color(0xFFB85C5C),
                          fontSize: 13,
                        ),
                      ),
                    ),
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
    return Row(
      children: [
        _ProfileAvatar(user: user),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (user?.name.trim().isNotEmpty ?? false)
                    ? user?.name ?? 'Delivery Partner'
                    : 'Delivery Partner',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB5B5B5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    user?.canOnline == true ? 'Online' : 'Offline',
                    style: const TextStyle(
                      color: Color(0xFF8A8A8A),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Get.to(() => const NotificationPage()),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF353535),
                ),
              ),
              Positioned(
                top: 8,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});

  final DeliveryPartner? user;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user?.profileImage ?? '';
    final initials = _initials(user?.name);

    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF4CAF50),
      ),
      child: ClipOval(
        child: imageUrl.isEmpty
            ? Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 120,
                maxWidthDiskCache: 160,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                errorWidget: (_, _, _) => Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard({required this.isOnline, required this.canToggle});

  final bool isOnline;
  final bool canToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF5C5B5A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70, width: 2),
            ),
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline ? const Color(0xFF7ED957) : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnline ? 'You are Online' : 'You are Offline',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  canToggle
                      ? 'Toggle to start receiving orders'
                      : 'Complete profile setup to receive orders',
                  style: const TextStyle(
                    color: Color(0xFFD9D9D9),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _StatusSwitch(isOnline: isOnline, canToggle: canToggle),
        ],
      ),
    );
  }
}

class _StatusSwitch extends StatelessWidget {
  const _StatusSwitch({required this.isOnline, required this.canToggle});

  final bool isOnline;
  final bool canToggle;

  void _toggleStatus() {
    if (!canToggle) {
      Get.snackbar(
        'Action Required',
        'Complete profile setup to receive orders',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.find<HomeController>().toggleOnlineStatus(!isOnline);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleStatus,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 52,
        height: 30,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: canToggle
              ? (isOnline ? const Color(0xFF7ED957) : const Color(0xFF9A9A9A))
              : const Color(0xFF7C7C7C),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Align(
          alignment: isOnline ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: canToggle ? Colors.white : const Color(0xFFE0E0E0),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.value,
    required this.label,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String value;
  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF242424),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF5E5E5E),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF9C9C9C),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6DF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF2C66B)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFEF9A22),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isOnline
                  ? 'You are ready to receive new delivery orders'
                  : 'Go online to start receiving orders and earning',
              style: const TextStyle(
                color: Color(0xFFD37E12),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryHeader extends StatelessWidget {
  const _DeliveryHeader(this.title, this.count);

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '$count orders',
          style: const TextStyle(
            color: Color(0xFF777777),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _OrderSkeletonList extends StatelessWidget {
  const _OrderSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Container(
          height: 106,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
        );
      },
    );
  }
}

class _EmptyDeliveries extends StatelessWidget {
  const _EmptyDeliveries();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        'No completed deliveries yet. Pull to refresh after your next order.',
        style: TextStyle(
          color: Color(0xFF6B6B6B),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
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
  final first = parts.first.isNotEmpty ? parts.first[0] : '';
  final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
  return (first + second).toUpperCase();
}

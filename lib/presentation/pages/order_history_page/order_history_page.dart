import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/order_history_controller.dart';
import '../../widgets/connectivity_gate.dart';
import '../../widgets/order_card.dart';

class OrderHistoryPage extends GetView<OrderHistoryController> {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityGate(
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F6F2),
        body: SafeArea(
          child: Obx(() {
            final displayedOrders = controller.filteredOrders;

            return RefreshIndicator(
              color: const Color(0xFF2E7D32),
              onRefresh: controller.refreshOrders,
              child: ListView(
                controller: controller.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Order History',
                    style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Review your performance and delivery logs.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _StatusFilterRow(controller: controller),
                  const SizedBox(height: 12),

                  _SecondaryFilterRow(controller: controller),
                  const SizedBox(height: 32),

                  if (controller.isLoading.value && controller.orders.isEmpty)
                    Column(
                      children: List.generate(
                        3,
                        (index) => Container(
                          height: 160,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    )
                  else if (displayedOrders.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.history_rounded,
                            size: 64,
                            color: Colors.black12,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No orders found',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: displayedOrders
                          .map((order) => OrderCard(order: order))
                          .toList(),
                    ),

                  if (!controller.isLoading.value &&
                      controller.orders.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _WeeklySummaryCard(orders: controller.orders),
                    const SizedBox(height: 40),
                  ],

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

class _StatusFilterRow extends StatelessWidget {
  const _StatusFilterRow({required this.controller});
  final OrderHistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 10,
        children: [
          _FilterChip(
            label: 'All Orders',
            isSelected: controller.statusFilter.value == 'All',
            onTap: () => controller.statusFilter.value = 'All',
          ),
          _FilterChip(
            label: 'Delivered',
            isSelected: controller.statusFilter.value == 'Completed',
            onTap: () => controller.statusFilter.value = 'Completed',
          ),
          _FilterChip(
            label: 'In Progress',
            isSelected: controller.statusFilter.value == 'Pending',
            onTap: () => controller.statusFilter.value = 'Pending',
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1B5E20)
              : const Color(0xFFD1E9F6).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : const Color(0xFF2E7D32),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SecondaryFilterRow extends StatelessWidget {
  const _SecondaryFilterRow({required this.controller});
  final OrderHistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: [
        _SecondaryButton(
          icon: Icons.calendar_today_rounded,
          label: 'Last 30 Days',
          onTap: () {},
        ),
        _SecondaryButton(
          icon: Icons.filter_list_rounded,
          label: 'High Value',
          onTap: () {},
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFD1E9F6).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: const Color(0xFF2E7D32).withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklySummaryCard extends StatelessWidget {
  const _WeeklySummaryCard({required this.orders});
  final List<dynamic> orders;

  @override
  Widget build(BuildContext context) {
    double revenue = 0;
    for (var o in orders) {
      if (o.status.toLowerCase() == 'delivered' ||
          o.status.toLowerCase() == 'completed') {
        revenue += o.amount;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            'https://www.transparenttextures.com/patterns/cubes.png',
          ),
          opacity: 0.1,
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Summary',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have completed ${orders.length} deliveries this week with a 98% satisfaction rate.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REVENUE',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white54,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs ${revenue.toStringAsFixed(2)}',
                    style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HOURS',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white54,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '32.5h',
                    style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

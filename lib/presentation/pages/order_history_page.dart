import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/order_history_controller.dart';
import '../widgets/connectivity_gate.dart';
import '../widgets/custom_header.dart';
import '../widgets/order_card.dart';

class OrderHistoryPage extends GetView<OrderHistoryController> {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityGate(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F5F2),
        body: Obx(() {
          final displayedOrders = controller.filteredOrders;

          return RefreshIndicator(
            color: const Color(0xFF4CAF50),
            onRefresh: controller.refreshOrders,
            child: ListView(
              controller: controller.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              cacheExtent: 1400,
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                CustomHeader(
                  title: 'Order History',
                  subtitle: 'Review and track your past deliveries',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${displayedOrders.length} orders',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  bottom: _FilterBar(controller: controller),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      if (controller.isLoading.value &&
                          controller.orders.isEmpty)
                        const _OrderSkeletonList()
                      else if (displayedOrders.isEmpty)
                        const _EmptyDeliveries()
                      else
                        ListView.builder(
                          itemCount: displayedOrders.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return OrderCard(order: displayedOrders[index]);
                          },
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
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.controller});

  final OrderHistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _FilterChip(
            label: 'All',
            isSelected: controller.statusFilter.value == 'All',
            onTap: () => controller.statusFilter.value = 'All',
          ),
          _FilterChip(
            label: 'Completed',
            isSelected: controller.statusFilter.value == 'Completed',
            onTap: () => controller.statusFilter.value = 'Completed',
          ),
          _FilterChip(
            label: 'Pending',
            isSelected: controller.statusFilter.value == 'Pending',
            onTap: () => controller.statusFilter.value = 'Pending',
          ),
          _FilterChip(
            label: 'Failed',
            isSelected: controller.statusFilter.value == 'Failed',
            onTap: () => controller.statusFilter.value = 'Failed',
          ),
          _DateFilterChip(
            selectedDate: controller.dateFilter.value,
            onTap: () async {
              if (controller.dateFilter.value != null) {
                controller.dateFilter.value = null;
                return;
              }
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF4CAF50),
                        onPrimary: Colors.white,
                        onSurface: Color(0xFF333333),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                controller.dateFilter.value = date;
              }
            },
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E20) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1B5E20)
                : Colors.white.withValues(alpha: 0.6),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2E7D32),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DateFilterChip extends StatelessWidget {
  const _DateFilterChip({required this.selectedDate, required this.onTap});

  final DateTime? selectedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasDate = selectedDate != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: hasDate ? const Color(0xFF1B5E20) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: hasDate
                ? const Color(0xFF1B5E20)
                : Colors.white.withValues(alpha: 0.6),
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 16,
              color: hasDate ? Colors.white : const Color(0xFF2E7D32),
            ),
            const SizedBox(width: 6),
            Text(
              hasDate
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : 'Date',
              style: TextStyle(
                color: hasDate ? Colors.white : const Color(0xFF2E7D32),
                fontSize: 14,
                fontWeight: hasDate ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            if (hasDate) ...[
              const SizedBox(width: 4),
              const Icon(Icons.close_rounded, size: 14, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}

class _OrderSkeletonList extends StatelessWidget {
  const _OrderSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
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
        'No deliveries matching your filters found.',
        style: TextStyle(
          color: Color(0xFF6B6B6B),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

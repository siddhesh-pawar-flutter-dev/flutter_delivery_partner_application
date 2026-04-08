import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/app_pages.dart';
import '../../core/utils/app_theme.dart';
import '../controllers/home_controller.dart';
import '../widgets/connectivity_gate.dart';
import '../widgets/empty_state.dart';
import '../widgets/order_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return ConnectivityGate(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              onPressed: () => Get.toNamed(AppPages.profile),
              icon: const Icon(Icons.person_outline_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.refreshOrders,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                children: [
                  // Obx(() =>
                   _HomeHeader(controller: controller),
                  //  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value && controller.orders.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.errorMessage.value.isNotEmpty &&
                          controller.orders.isEmpty) {
                        return EmptyState(
                          title: 'Unable to load orders',
                          subtitle: controller.errorMessage.value,
                        );
                      }

                      if (controller.orders.isEmpty) {
                        return const EmptyState(
                          title: 'No orders yet',
                          subtitle: 'Completed deliveries will appear here.',
                        );
                      }

                      return ListView.builder(
                        controller: controller.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount:
                            controller.orders.length +
                            (controller.isLoadingMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == controller.orders.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return OrderCard(order: controller.orders[index]);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final user = controller.user;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF243227), Color(0xFF171A1D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppTheme.primary.withValues(alpha: 0.16),
                child: const Icon(Icons.person_outline_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Delivery Partner',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user?.city ?? 'City'}${(user?.state ?? '').isNotEmpty ? ', ${user?.state}' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _MetricTile(
                label: 'Outstanding',
                value: 'Rs ${user?.totalDeductionBalance.toStringAsFixed(0) ?? '0'}',
              ),
              const SizedBox(width: 12),
              _MetricTile(
                label: 'Orders loaded',
                value: '${controller.orders.length}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

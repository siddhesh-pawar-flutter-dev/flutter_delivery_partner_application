import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/home_controller.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/main_shell_controller.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/availability_toggle.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/delivery_list_header.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/greeting_section.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/section_header.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/statistics_grid.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/top_bar.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/weekly_earnings_card.dart';
import 'package:flutter_delivery_partner_application/presentation/widgets/active_order_section.dart';
import 'package:flutter_delivery_partner_application/presentation/widgets/connectivity_gate.dart';
import 'package:flutter_delivery_partner_application/presentation/widgets/order_card.dart';
import 'package:flutter_delivery_partner_application/presentation/widgets/tshirt_card.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConnectivityGate(
      child: SafeArea(
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
                    TopBar(user: user),
                    const SizedBox(height: 32),

                    const GreetingSection(),

                    const SizedBox(height: 16),

                    const AvailabilityToggle(),

                    const SizedBox(height: 32),

                    if (controller.shouldShowTshirtCard)
                      const Column(
                        children: [TshirtCard(), SizedBox(height: 32)],
                      ),

                    SectionHeader(
                      title: 'Active Deliveries',
                      icon: Icons.restaurant_rounded,
                      count: controller.todayActiveCount,
                    ),
                    const SizedBox(height: 16),
                    if (controller.activeOrder != null)
                      ActiveOrderSection(order: controller.activeOrder!)
                    else
                      Container(
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
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.3,
                              ),
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No active deliveries',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),

                    const WeeklyEarningsCard(),

                    const SizedBox(height: 32),

                    const SectionHeader(title: 'Overview'),

                    const SizedBox(height: 16),

                    const StatisticsGrid(),

                    const SizedBox(height: 32),

                    DeliveryListHeader(count: displayedOrders.length),
                    const SizedBox(height: 16),
                    if (controller.isLoading.value && controller.orders.isEmpty)
                      Column(
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
                      )
                    else if (displayedOrders.isEmpty)
                      const Center(
                        child: Text(
                          'No completed deliveries yet.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
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
                        ScaleInteraction(
                          onTap: () => Get.find<MainShellController>().goTo(1),

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
                        ),
                      ],
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

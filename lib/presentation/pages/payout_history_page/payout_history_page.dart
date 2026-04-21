import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/payout_history_page/components/payout_card.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/payout_history_page/components/payout_filter_chip.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/payout_history_page/payout_filters.dart';
import 'package:get/get.dart';
import '../../controllers/payout_history_controller.dart';
import '../../widgets/empty_state.dart';

class PayoutHistoryPage extends GetView<PayoutHistoryController> {
  const PayoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F6F2),
        elevation: 0,
        title: const Text(
          'Payout History',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.payouts.isEmpty) {
                return Center(
                  child: EmptyState(
                    title: 'Failed to load payouts',
                    subtitle: controller.errorMessage.value,
                  ),
                );
              }

              if (controller.payouts.isEmpty) {
                return const Center(
                  child: EmptyState(
                    title: 'No Payout History',
                    subtitle: 'You have not received any payouts yet.',
                  ),
                );
              }

              final displayedPayouts = controller.filteredPayouts;

              return RefreshIndicator(
                color: const Color(0xFF4CAF50),
                onRefresh: controller.loadInitialData,
                child: ListView.separated(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 80, // Padding for bottom navbar
                  ),
                  itemCount:
                      1 +
                      (displayedPayouts.isEmpty ? 1 : displayedPayouts.length) +
                      (controller.isLoadingMore.value ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return PayoutFilters(controller: controller);
                    }

                    final payoutIndex = index - 1;

                    if (displayedPayouts.isEmpty) {
                      if (payoutIndex == 0) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: EmptyState(
                            title: 'No payouts found',
                            subtitle: '',
                          ),
                        );
                      }

                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      );
                    }

                    if (payoutIndex == displayedPayouts.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      );
                    }

                    final payout = displayedPayouts[payoutIndex];
                    return PayoutCard(
                      orderId: payout.orderId,
                      amount: payout.amount,
                      deductAmount: payout.deductAmount,
                      status: payout.status,
                      createdAt: payout.createdAt,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

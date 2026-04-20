import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/payout_history_page/components/payout_card.dart';
import 'package:get/get.dart';
import '../../controllers/payout_history_controller.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/empty_state.dart';

class PayoutHistoryPage extends GetView<PayoutHistoryController> {
  const PayoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: Column(
        children: [
          CustomHeader(
            title: 'Payout History',
            subtitle: 'Review your settlements & earnings',
            trailing: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
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
                      controller.payouts.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == controller.payouts.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      );
                    }

                    final payout = controller.payouts[index];
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

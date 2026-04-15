import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/formatters.dart';
import '../controllers/payout_history_controller.dart';
import '../widgets/custom_header.dart';
import '../widgets/empty_state.dart';

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
                    itemCount: controller.payouts.length +
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
                      return _PayoutCard(
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


class _PayoutCard extends StatelessWidget {
  const _PayoutCard({
    required this.orderId,
    required this.amount,
    required this.deductAmount,
    required this.status,
    required this.createdAt,
  });

  final int orderId;
  final double amount;
  final double deductAmount;
  final String status;
  final String createdAt;

  String _formatDate(String dateString) {
    try {
      final parsed = DateTime.parse(dateString);
      return Formatters.formatDateTime(parsed, format: 'dd/MM/yyyy • hh:mm a');
    } catch (_) {
      return dateString;
    }
  }

  Color _getStatusColor(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'settled' || lowerStatus == 'completed') {
      return const Color(0xFF4CAF50);
    } else if (lowerStatus.contains('not_settle') || lowerStatus == 'pending') {
      return const Color(0xFFFF9800);
    }
    return const Color(0xFF434343);
  }
  
  String _getDisplayStatus(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'not_settle') return 'NOT SETTLED';
    return status.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(createdAt);
    final statusColor = _getStatusColor(status);
    final displayStatus = _getDisplayStatus(status);
    final netAmount = amount - deductAmount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Ripple effect visually, no external routing set for payouts yet
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: statusColor.withValues(alpha: 0.05),
          highlightColor: statusColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.receipt_long_rounded, size: 20, color: statusColor),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Order #$orderId',
                          style: const TextStyle(
                            color: Color(0xFF2F2F2F),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        displayStatus,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Color(0xFF8E8E8E),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        label: 'Gross',
                        value: '₹${amount.toStringAsFixed(2)}',
                        icon: Icons.payments_rounded,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                    if (deductAmount > 0) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatBox(
                          label: 'Deduct',
                          value: '-₹${deductAmount.toStringAsFixed(2)}',
                          icon: Icons.money_off_csred_rounded,
                          color: const Color(0xFFFF5E67),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatBox(
                          label: 'Net Pay',
                          value: '₹${netAmount.toStringAsFixed(2)}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: const Color(0xFF2196F3),
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF8E8E8E),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

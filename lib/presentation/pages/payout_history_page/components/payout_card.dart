import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/core/utils/formatters.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/payout_history_page/components/stat_box.dart';

class PayoutCard extends StatelessWidget {
  const PayoutCard({
    super.key,
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
                          child: Icon(
                            Icons.receipt_long_rounded,
                            size: 20,
                            color: statusColor,
                          ),
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
                      child: StatBox(
                        label: 'Gross',
                        value: '₹${amount.toStringAsFixed(2)}',
                        icon: Icons.payments_rounded,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                    if (deductAmount > 0) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatBox(
                          label: 'Deduct',
                          value: '-₹${deductAmount.toStringAsFixed(2)}',
                          icon: Icons.money_off_csred_rounded,
                          color: const Color(0xFFFF5E67),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatBox(
                          label: 'Net Pay',
                          value: '₹${netAmount.toStringAsFixed(2)}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: const Color(0xFF2196F3),
                        ),
                      ),
                    ],
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

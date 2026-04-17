import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities/delivery_order.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final DeliveryOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scheduledAt =
        Formatters.parseDateTime(order.scheduledAt) ??
        Formatters.parseDateTime(order.createdAt);

    return GestureDetector(
      onTap: () => Get.toNamed('/order-detail', arguments: order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Order ID & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ORD-${order.id}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black26,
                    letterSpacing: 0.5,
                  ),
                ),
                _StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 12),

            // Restaurant Name
            Text(
              order.restaurantName,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Item Summary
            Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 16,
                  color: Colors.black38,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.itemSummary.isEmpty
                        ? '${order.quantity} items'
                        : order.itemSummary,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date & Time
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.black38),
                const SizedBox(width: 8),
                Text(
                  Formatters.formatDateTime(scheduledAt),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Bottom Section: Grand Total
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _getTonalColor(order.status).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black45,
                    ),
                  ),
                  Text(
                    'Rs ${order.amount.toStringAsFixed(2)}',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: _getTonalColor(order.status),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTonalColor(String status) {
    final normalized = status.trim().toLowerCase();
    switch (normalized) {
      case 'accepted':
      case 'delivered':
      case 'completed':
        return const Color(0xFF2E7D32);
      case 'picked':
      case 'picked up':
      case 'pending':
      case 'in progress':
        return const Color(0xFFC2185B); // Rose tonal for in progress
      case 'cancelled':
      case 'failed':
      case 'not accepted':
      case 'not_accepted':
      case 'user_not_accepted':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFF2E7D32);
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.trim().toLowerCase();
    Color bgColor;
    Color textColor;
    String label = status.trim().replaceAll('_', ' ').toUpperCase();

    if (normalized == 'completed' || normalized == 'delivered') {
      bgColor = const Color(0xFFC8E6C9);
      textColor = const Color(0xFF2E7D32);
      label = 'DELIVERED';
    } else if (normalized == 'cancelled' ||
        normalized == 'failed' ||
        normalized.contains('not_accepted')) {
      bgColor = const Color(0xFFFFCDD2);
      textColor = const Color(0xFFC62828);
      label = 'CANCELLED';
    } else {
      // In Progress / Pending
      bgColor = const Color(0xFFFCE4EC);
      textColor = const Color(0xFFC2185B);
      label = 'IN PROGRESS';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

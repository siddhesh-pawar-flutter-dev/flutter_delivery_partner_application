import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/domain/entities/delivery_order.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderHeaderCard extends StatelessWidget {
  const OrderHeaderCard({super.key, required this.order});

  final DeliveryOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.restaurantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _StatusBadge(status: order.status),
            ],
          ),
          if (order.itemSummary.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              order.itemSummary,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.receipt_long_rounded,
                text: 'ORD-${order.id}',
              ),
              _InfoChip(
                icon: Icons.shopping_bag_outlined,
                text: '${order.quantity} items',
              ),
              _InfoChip(
                icon: order.isCod
                    ? Icons.payments_outlined
                    : Icons.wallet_outlined,
                text: order.isCod ? 'Cash on delivery' : 'Prepaid',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.trim().toLowerCase();
    final isDone = normalized == 'completed' || normalized == 'delivered';
    final isFailed =
        normalized == 'cancelled' ||
        normalized == 'failed' ||
        normalized == 'not accepted' ||
        normalized == 'not_accepted' ||
        normalized == 'user_not_accepted';

    final bgColor = isDone
        ? const Color(0xFFC8E6C9)
        : isFailed
        ? const Color(0xFFFFCDD2)
        : const Color(0xFFFCE4EC);
    final textColor = isDone
        ? const Color(0xFF2E7D32)
        : isFailed
        ? const Color(0xFFC62828)
        : const Color(0xFFC2185B);
    final label = status.trim().isEmpty
        ? 'PENDING'
        : status.trim().replaceAll('_', ' ').toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

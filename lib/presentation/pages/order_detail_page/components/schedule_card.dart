import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/core/utils/formatters.dart';
import 'package:flutter_delivery_partner_application/domain/entities/delivery_order.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.order});

  final DeliveryOrder order;

  @override
  Widget build(BuildContext context) {
    final scheduledAt = Formatters.parseDateTime(order.scheduledAt);
    final scheduleText = scheduledAt == null
        ? 'Schedule not available'
        : Formatters.formatDateTime(scheduledAt);
    final detailText = order.pickupTime.trim().isNotEmpty
        ? 'Pickup time: ${order.pickupTime}'
        : 'Created: ${_createdAtText(order.createdAt)}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SCHEDULE',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.white60,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            scheduleText,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.access_time_filled,
                size: 14,
                color: Colors.white60,
              ),
              const SizedBox(width: 6),
              Text(
                detailText,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _createdAtText(String createdAt) {
    final parsed = Formatters.parseDateTime(createdAt);
    if (parsed == null) return '--';
    return Formatters.formatDateTime(parsed);
  }
}

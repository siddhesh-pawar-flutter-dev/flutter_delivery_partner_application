import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/domain/entities/delivery_order.dart';
import 'package:google_fonts/google_fonts.dart';

class EarningsCard extends StatelessWidget {
  const EarningsCard({super.key, required this.order});

  final DeliveryOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EARNINGS',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.black38,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rs ${order.amount.toStringAsFixed(2)}',
            style: GoogleFonts.manrope(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _MetaRow(
            icon: Icons.wallet_outlined,
            text: order.paymentStatus.isEmpty ? '--' : order.paymentStatus,
          ),
          const SizedBox(height: 8),
          _MetaRow(
            icon: Icons.local_shipping_outlined,
            text: order.deliveryType.isEmpty ? '--' : order.deliveryType,
          ),
        ],
      ),
    );
  }
}
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.black26),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/order_detail_page/components/bottom_action_row.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/order_detail_page/components/business_contact_card.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/order_detail_page/components/customer_contact_card.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/order_detail_page/components/earnings_card.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/order_detail_page/components/order_header_card.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/order_detail_page/components/order_image_card.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/order_detail_page/components/order_summary_card.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/order_detail_page/components/schedule_card.dart';
import 'package:get/get.dart';
import '../../../domain/entities/delivery_order.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final order = Get.arguments as DeliveryOrder?;

    if (order == null) {
      return const Scaffold(body: Center(child: Text('Order not found')));
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    OrderImageCard(order: order),
                    const SizedBox(height: 16),
                    OrderHeaderCard(order: order),
                    const SizedBox(height: 16),
                    EarningsCard(order: order),
                    const SizedBox(height: 16),
                    ScheduleCard(order: order),
                    const SizedBox(height: 16),
                    BusinessContactCard(order: order),
                    const SizedBox(height: 16),
                    CustomerContactCard(order: order),
                    const SizedBox(height: 16),
                    OrderSummaryCard(order: order),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const BottomActionRow(),
          ],
        ),
      ),
    );
  }
}

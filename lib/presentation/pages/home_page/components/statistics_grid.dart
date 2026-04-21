import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/home_controller.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/status_tile.dart';
import 'package:get/get.dart';

class StatisticsGrid extends GetView<HomeController> {
  const StatisticsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,

        children: [
          StatusTile(
            icon: Icons.lunch_dining_rounded,
            label: 'Deliveries Done',
            value: '${controller.todayCompletedCount}',
            color: const Color(0xFF7c5c46),
            backgroundColor: const Color(0xFFfdecdb),
          ),
          StatusTile(
            icon: Icons.shopping_bag_rounded,
            label: 'Available Deliveries',
            value: '08',
            color: const Color(0xFF2E7D32),
            backgroundColor: const Color(0xFFccf5cc),
          ),
          StatusTile(
            icon: Icons.local_offer_rounded,
            label: 'New Offers',
            value: '12',
            badgeText: '+2 New',
            color: const Color(0xFFd9435e),
            backgroundColor: const Color(0xFFffd9e2),
          ),
          StatusTile(
            icon: Icons.timeline_rounded,
            label: 'Total Career',
            value: '1,482',
            unit: 'DELIVERIES',
            color: const Color(0xFF455A64),
            backgroundColor: const Color(0xFFCFE6F2),
          ),
        ],
      ),
    );
  }
}

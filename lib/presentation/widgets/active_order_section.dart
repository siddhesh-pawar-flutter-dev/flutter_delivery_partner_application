import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/app_pages.dart';
import '../../domain/entities/delivery_order.dart';

class ActiveOrderSection extends StatelessWidget {
  const ActiveOrderSection({required this.order, super.key});

  final DeliveryOrder order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Active Order',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Get.toNamed('/order-detail', arguments: order),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
          child: Column(
            children: [
              // Order Header with Image and Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    // Order Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: order.imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: order.imageUrl,
                                fit: BoxFit.cover,
                                memCacheWidth: 160,
                                maxWidthDiskCache: 200,
                                fadeInDuration: Duration.zero,
                                fadeOutDuration: Duration.zero,
                                errorWidget: (_, _, _) => Container(
                                  color: const Color(0xFFF0F0F0),
                                  child: const Icon(
                                    Icons.fastfood_rounded,
                                    color: Color(0xFFC0C0C0),
                                  ),
                                ),
                              )
                            : Container(
                                color: const Color(0xFFF0F0F0),
                                child: const Icon(
                                  Icons.fastfood_rounded,
                                  color: Color(0xFFC0C0C0),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Order Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Order ID and Amount
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  'Order #${order.id}',
                                  style: const TextStyle(
                                    color: Color(0xFF2B2B2B),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                '₹${order.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFF2B2B2B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Restaurant Name
                          Text(
                            order.restaurantName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.status)
                                  .withAlpha(26),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _formatStatus(order.status),
                              style: TextStyle(
                                color: _getStatusColor(order.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Divider
              Container(
                height: 1,
                color: const Color(0xFFEFEFEF),
              ),
              // Pickup and Drop-off Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Pickup Section
                    _LocationRow(
                      icon: Icons.location_on_rounded,
                      iconColor: const Color(0xFF2F9D57),
                      label: 'Pickup',
                      location: order.pickupAddress.isNotEmpty
                          ? order.pickupAddress
                          : order.pickupArea,
                      time: order.pickupTime.isNotEmpty
                          ? order.pickupTime
                          : 'Pick up time',
                    ),
                    const SizedBox(height: 16),
                    // Drop-off Section
                    _LocationRow(
                      icon: Icons.location_on_rounded,
                      iconColor: const Color(0xFFE94F56),
                      label: 'Drop-off',
                      location: order.address.isNotEmpty
                          ? order.address
                          : order.dropCity,
                      time: '',
                    ),
                  ],
                ),
              ),
              // Divider
              Container(
                height: 1,
                color: const Color(0xFFEFEFEF),
              ),
              // View Details Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Get.toNamed(AppPages.orderDetail,
                          arguments: {'orderId': order.id}),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A2633),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'View Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    final normalized = status.trim().toLowerCase();
    switch (normalized) {
      case 'accepted':
      case 'delivered':
      case 'completed':
        return const Color(0xFF2F9D57);
      case 'picked':
      case 'picked up':
      case 'pending':
        return const Color(0xFF2E7AD7);
      case 'cancelled':
      case 'failed':
      case 'not accepted':
      case 'not_accepted':
      case 'user_not_accepted':
        return const Color(0xFFE94F56);
      default:
        return const Color(0xFF666666);
    }
  }

  String _formatStatus(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized == 'not accepted' || normalized == 'not_accepted' || normalized == 'user_not_accepted') {
      return 'FAILED';
    }
    return status.trim().replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.location,
    required this.time,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String location;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF8A8A8A),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                location,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (time.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    time,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

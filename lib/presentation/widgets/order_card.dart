import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities/delivery_order.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final DeliveryOrder order;

  @override
  Widget build(BuildContext context) {
    final scheduledAt =
        Formatters.parseDateTime(order.scheduledAt) ??
        Formatters.parseDateTime(order.createdAt);

    return GestureDetector(
      onTap: () => Get.toNamed('/order-detail', arguments: order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: order.imageUrl.isEmpty
                  ? _fallbackImage()
                  : CachedNetworkImage(
                      imageUrl: order.imageUrl,
                      width: 62,
                      height: 62,
                      fit: BoxFit.cover,
                      memCacheWidth: 240,
                      memCacheHeight: 240,
                      maxWidthDiskCache: 320,
                      maxHeightDiskCache: 320,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      placeholder: (_, _) =>
                          _fallbackImage(icon: Icons.image_outlined),
                      errorWidget: (_, _, _) => _fallbackImage(),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          order.restaurantName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF2C2C2C),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _statusBadgeBackground(order.status),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _statusLabel(order.status),
                          style: TextStyle(
                            color: _statusBadgeColor(order.status),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _routeLabel(order),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF848484),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF8EF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Rs ${order.amount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFF2F9D57),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.inventory_2_outlined,
                        color: Color(0xFFAAAAAA),
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${order.quantity} item${order.quantity == 1 ? '' : 's'}',
                        style: const TextStyle(
                          color: Color(0xFF8B8B8B),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTime(scheduledAt),
                        style: const TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    order.itemSummary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF5F5F5F),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

  Widget _fallbackImage({IconData icon = Icons.fastfood_rounded}) {
    return Container(
      width: 62,
      height: 62,
      color: const Color(0xFFF1F1F1),
      child: Icon(icon, color: const Color(0xFFBDBDBD)),
    );
  }
}

String _statusLabel(String status) {
  final normalized = status.trim().toLowerCase();
  
  if (normalized.isEmpty) return 'Delivered';
  if (normalized == 'not accepted' || normalized == 'not_accepted' || normalized == 'user_not_accepted') {
    return 'Failed';
  }
  
  return normalized
      .replaceAll('_', ' ')
      .split(RegExp(r'\s+'))
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1)}',
      )
      .join(' ');
}

String _routeLabel(DeliveryOrder order) {
  final pickup = order.pickupArea.trim();
  final drop = order.dropCity.trim();
  if (pickup.isNotEmpty && drop.isNotEmpty) {
    return '$pickup -> $drop';
  }
  if (order.address.trim().isNotEmpty) {
    return order.address;
  }
  return 'Delivery route unavailable';
}

String _formatTime(DateTime? value) {
  if (value == null) return '--';
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  final minute = value.minute.toString().padLeft(2, '0');
  final suffix = value.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}

Color _statusBadgeColor(String status) {
  final normalized = status.trim().toLowerCase();
  if (normalized == 'completed' || normalized == 'delivered') {
    return const Color(0xFF2F9D57); // Green
  }
  if (normalized == 'cancelled' ||
      normalized == 'failed' ||
      normalized == 'not accepted' ||
      normalized == 'not_accepted' ||
      normalized == 'user_not_accepted') {
    return const Color(0xFFE94F56); // Red
  }
  if (normalized == 'accepted' || normalized == 'picked' || normalized == 'picked up') {
    return const Color(0xFF2E7AD7); // Blue
  }
  return const Color(0xFFD08000); // Orange/amber for pending/other
}

Color _statusBadgeBackground(String status) {
  final normalized = status.trim().toLowerCase();
  if (normalized == 'completed' || normalized == 'delivered') {
    return const Color(0xFFEAF8EF); // Light green
  }
  if (normalized == 'cancelled' ||
      normalized == 'failed' ||
      normalized == 'not accepted' ||
      normalized == 'not_accepted' ||
      normalized == 'user_not_accepted') {
    return const Color(0xFFFFECEC); // Light red
  }
  if (normalized == 'accepted' || normalized == 'picked' || normalized == 'picked up') {
    return const Color(0xFFE8F1FD); // Light blue
  }
  return const Color(0xFFFFF5DE); // Light orange/amber for pending/other
}

import 'package:cached_network_image/cached_network_image.dart';
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.surfaceContainerLow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: order.imageUrl.isEmpty
                    ? _fallbackImage(colorScheme)
                    : CachedNetworkImage(
                        imageUrl: order.imageUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        memCacheWidth: 240,
                        memCacheHeight: 240,
                        placeholder: (_, _) =>
                            _fallbackImage(colorScheme, icon: Icons.image_outlined),
                        errorWidget: (_, _, _) => _fallbackImage(colorScheme),
                      ),
              ),
            ),
            const SizedBox(width: 16),
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
                          style: GoogleFonts.manrope(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusBadgeBackground(context, order.status),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _statusLabel(order.status),
                          style: GoogleFonts.inter(
                            color: _statusBadgeColor(context, order.status),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 14, color: colorScheme.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _routeLabel(order),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Rs ${order.amount.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            color: colorScheme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${order.quantity} item${order.quantity == 1 ? '' : 's'}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTime(scheduledAt),
                        style: GoogleFonts.inter(
                          color: colorScheme.outline,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackImage(ColorScheme colorScheme, {IconData icon = Icons.fastfood_rounded}) {
    return Container(
      width: 64,
      height: 64,
      color: colorScheme.surfaceContainerHigh,
      child: Icon(icon, color: colorScheme.outline.withValues(alpha: 0.5)),
    );
  }
}

String _statusLabel(String status) {
  final normalized = status.trim().toLowerCase();

  if (normalized.isEmpty) return 'Delivered';
  if (normalized == 'not accepted' ||
      normalized == 'not_accepted' ||
      normalized == 'user_not_accepted') {
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
    return '$pickup to $drop';
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

Color _statusBadgeColor(BuildContext context, String status) {
  final colorScheme = Theme.of(context).colorScheme;
  final normalized = status.trim().toLowerCase();
  
  if (normalized == 'completed' || normalized == 'delivered') {
    return colorScheme.primary;
  }
  if (normalized == 'cancelled' ||
      normalized == 'failed' ||
      normalized == 'not accepted' ||
      normalized == 'not_accepted' ||
      normalized == 'user_not_accepted') {
    return colorScheme.error;
  }
  
  return const Color(0xFF923357); // tertiary from design system
}

Color _statusBadgeBackground(BuildContext context, String status) {
  final colorScheme = Theme.of(context).colorScheme;
  final normalized = status.trim().toLowerCase();
  
  if (normalized == 'completed' || normalized == 'delivered') {
    return colorScheme.primary.withValues(alpha: 0.1);
  }
  if (normalized == 'cancelled' ||
      normalized == 'failed' ||
      normalized == 'not accepted' ||
      normalized == 'not_accepted' ||
      normalized == 'user_not_accepted') {
    return colorScheme.errorContainer.withValues(alpha: 0.5);
  }
  
  return const Color(0xFFFDE7EF); // tertiary container light
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/app_pages.dart';
import '../../domain/entities/delivery_order.dart';

class ActiveOrderSection extends StatelessWidget {
  const ActiveOrderSection({required this.order, super.key});

  final DeliveryOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScaleInteraction(
      onTap: () => Get.toNamed(AppPages.orderDetail, arguments: order),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // 1. Signature Accent Stripe
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Status Badge and Delivery Est.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatusBadge(status: order.status),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'EST. DELIVERY',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                ),
                              ),
                              Text(
                                '14:30 PM', // Placeholder for actual est. time if available
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontSize: 18,
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 3. Information Content
                      Text(
                        'Order #${order.id}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${order.restaurantName} (${order.quantity} items)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 4. No-Line Address Block (Tonal Shift)
                      _AddressSegment(order: order),

                      const SizedBox(height: 24),

                      // 5. Actions
                      Row(
                        children: [
                          Expanded(
                            child: _NavigateButton(
                              onTap: () => Get.toNamed(AppPages.orderDetail, arguments: order),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _CallButton(onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'IN TRANSIT',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressSegment extends StatelessWidget {
  const _AddressSegment({required this.order});
  final DeliveryOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _LocationRow(
            icon: Icons.store_rounded,
            address: order.pickupAddress.isNotEmpty ? order.pickupAddress : order.pickupArea,
            isStart: true,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 4, bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 12,
                child: VerticalDivider(
                  color: Color(0xFFC4C4C4),
                  width: 1,
                  thickness: 1,
                ),
              ),
            ),
          ),
          _LocationRow(
            icon: Icons.location_on_rounded,
            address: order.address.isNotEmpty ? order.address : order.dropCity,
            isStart: false,
          ),
        ],
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.icon, required this.address, required this.isStart});
  final IconData icon;
  final String address;
  final bool isStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isStart ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              fontWeight: isStart ? FontWeight.w500 : FontWeight.w700,
              color: isStart ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavigateButton extends StatelessWidget {
  const _NavigateButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Navigate',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.directions_car_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.call_rounded, color: colorScheme.primary, size: 22),
      ),
    );
  }
}

// Signature Component: ScaleInteraction
class ScaleInteraction extends StatefulWidget {
  const ScaleInteraction({required this.child, required this.onTap, super.key});
  final Widget child;
  final VoidCallback onTap;

  @override
  State<ScaleInteraction> createState() => _ScaleInteractionState();
}

class _ScaleInteractionState extends State<ScaleInteraction> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

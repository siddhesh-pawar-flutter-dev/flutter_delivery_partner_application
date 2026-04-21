import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/home_controller.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/toggle_half_indicator.dart';
import 'package:get/get.dart';

class AvailabilityToggle extends GetView<HomeController> {
  const AvailabilityToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final isOnline = controller.canReceiveOrders;
      return Container(
        height: 52,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutBack,
              alignment: isOnline
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isOnline
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: isOnline
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                ToggleHalfIndicator(
                  label: 'Online',
                  isActive: isOnline,
                  onTap: () => controller.toggleOnlineStatus(true),
                ),
                ToggleHalfIndicator(
                  label: 'Offline',
                  isActive: !isOnline,
                  onTap: () => controller.toggleOnlineStatus(false),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

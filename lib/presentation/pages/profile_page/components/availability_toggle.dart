import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/profile_controller.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/profile_page/components/toggle_button.dart';
import 'package:get/get.dart';

class AvailabilityToggle extends GetView<ProfileController> {
  const AvailabilityToggle({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      final isOnline = controller.isOnline.value;
      return Container(
        height: 52,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            // Sliding Indicator
            AnimatedAlign(
              duration: const Duration(milliseconds: 750),
              curve:
                  Curves.easeInOutBack, // Gives a slight "bounce" to the slide
              alignment: isOnline
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: (isOnline ? Colors.green : Colors.red).withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: (isOnline ? Colors.green : Colors.red).withValues(
                        alpha: 0.4,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isOnline ? Colors.green : Colors.red)
                            .withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Interaction Layer
            Row(
              children: [
                Expanded(
                  child: ToggleButton(
                    label: 'Online',
                    isSelected: isOnline,
                    activeColor: Colors.green,
                    onTap: () {
                      if (!isOnline) controller.toggleOnline();
                    },
                  ),
                ),
                Expanded(
                  child: ToggleButton(
                    label: 'Offline',
                    isSelected: !isOnline,
                    activeColor: Colors.red,
                    onTap: () {
                      if (isOnline) controller.toggleOnline();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

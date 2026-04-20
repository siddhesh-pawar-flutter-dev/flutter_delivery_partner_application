import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/tshirt_selection_controller.dart';
import 'package:get/get.dart';

class SizeSelector extends StatelessWidget {
  const SizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TshirtSelectionController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Size",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: controller.sizeStock.keys.map((size) {
            final isAvailable = controller.sizeStock[size]!;

            return Obx(() {
              final isSelected = controller.selectedSize.value == size;

              return GestureDetector(
                onTap: isAvailable ? () => controller.selectSize(size) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? colorScheme.primary : colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha:0.3),
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha:0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        size,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (!isAvailable) ...[
                        const SizedBox(height: 4),
                        Text(
                          "Out of stock",
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}

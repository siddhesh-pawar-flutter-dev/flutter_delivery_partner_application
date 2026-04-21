import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/home_controller.dart';
import 'package:get/get.dart';

class GreetingSection extends GetView<HomeController> {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready for lunch rush?',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Obx(
          () => Text(
            'Hi, ${controller.greetingName}',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

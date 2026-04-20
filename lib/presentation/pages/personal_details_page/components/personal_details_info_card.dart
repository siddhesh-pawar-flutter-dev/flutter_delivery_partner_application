import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/personal_details_page/components/personal_details_info_item.dart';

class PersonalDetailsInfoCard extends StatelessWidget {
  const PersonalDetailsInfoCard({super.key, required this.items});
  final List<PersonalDetailsInfoItem> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1) const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}

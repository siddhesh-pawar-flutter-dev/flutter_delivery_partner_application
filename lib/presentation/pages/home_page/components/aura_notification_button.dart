import 'package:flutter/material.dart';

class AuraNotificationButton extends StatelessWidget {
  const AuraNotificationButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.green.shade300.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          Icons.notifications_none_rounded,
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }
}

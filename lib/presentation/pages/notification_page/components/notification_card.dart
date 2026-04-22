import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isUnread
              ? const Color(0xFFE9F6FD)
              : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: !notification.isUnread
              ? Border.all(
                  color: const Color(0xFFBFCABA).withValues(alpha: 0.1),
                )
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconOrImage(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification.title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111D23),
                        ),
                      ),
                      Text(
                        notification.time,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4C616C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _buildDescription(),
                  if (notification.actionLabel != null) ...[
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D631B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      child: Text(
                        notification.actionLabel!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (notification.isUnread) ...[
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D631B),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D631B).withValues(alpha: 0.1),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIconOrImage() {
    if (notification.imageUrl != null) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(notification.imageUrl!),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.1),
              BlendMode.darken,
            ),
          ),
        ),
      );
    }

    final config = _getIconConfig();
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: config.bgColor, shape: BoxShape.circle),
      child: Icon(config.icon, color: config.iconColor, size: 24),
    );
  }

  Widget _buildDescription() {
    final parts = notification.description.split('**');
    if (parts.length <= 1) {
      return Text(
        notification.description,
        style: GoogleFonts.inter(
          fontSize: 14,
          height: 1.5,
          color: const Color(0xFF40493D),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 14,
          height: 1.5,
          color: const Color(0xFF40493D),
        ),
        children: List.generate(parts.length, (index) {
          if (index % 2 == 1) {
            return TextSpan(
              text: parts[index],
              style: const TextStyle(fontWeight: FontWeight.w600),
            );
          }
          return TextSpan(text: parts[index]);
        }),
      ),
    );
  }

  _IconConfig _getIconConfig() {
    switch (notification.type) {
      case NotificationType.order:
        return _IconConfig(
          icon: Icons.inventory_2_outlined,
          bgColor: const Color(0xFFA3F69C),
          iconColor: const Color(0xFF005312),
        );
      case NotificationType.payment:
        return _IconConfig(
          icon: Icons.payments_outlined,
          bgColor: const Color(0xFFCFE6F2),
          iconColor: const Color(0xFF354A53),
        );
      case NotificationType.review:
        return _IconConfig(
          icon: Icons.stars_outlined,
          bgColor: const Color(0xFFE3F0F8),
          iconColor: const Color(0xFF40493D),
        );
      case NotificationType.account:
        return _IconConfig(
          icon: Icons.verified_outlined,
          bgColor: const Color(0xFFFFD9E2),
          iconColor: const Color(0xFF7F2448),
        );
      case NotificationType.system:
        return _IconConfig(
          icon: Icons.info_outline,
          bgColor: const Color(0xFFE3F0F8),
          iconColor: const Color(0xFF40493D),
        );
      default:
        return _IconConfig(
          icon: Icons.notifications_none_rounded,
          bgColor: const Color(0xFFE3F0F8),
          iconColor: const Color(0xFF40493D),
        );
    }
  }
}

class _IconConfig {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  _IconConfig({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}

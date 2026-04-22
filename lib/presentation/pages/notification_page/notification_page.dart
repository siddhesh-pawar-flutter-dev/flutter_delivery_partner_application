import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/notification_controller.dart';
import 'components/empty_notifications.dart';
import 'components/notification_card.dart';
import 'components/notification_header.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      body: SafeArea(
        child: Column(
          children: [
            const NotificationHeader(),
            Expanded(
              child: Obx(() {
                final grouped = controller.groupedNotifications;
                if (grouped.isEmpty) {
                  return const EmptyNotifications();
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  children: [
                    ...grouped.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
                            child: Text(
                              entry.key.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4C616C),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          ...entry.value.map((notification) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: NotificationCard(
                                notification: notification,
                                onTap: () => controller.markAsRead(notification.id),
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                    const _NotificationFooter(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationFooter extends StatelessWidget {
  const _NotificationFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Divider(color: Color(0x0F000000)),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D631B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.eco,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Easy Cater Logistics',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111D23),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '© 2024 Kinetic Framework • v2.4.0',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4C616C).withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

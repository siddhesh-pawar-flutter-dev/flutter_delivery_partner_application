import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/notification_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAFF).withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFBFCABA).withValues(alpha: 0.2),
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF111D23),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        hoverColor: const Color(0xFFDDEAF2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Obx(
                        () => Text(
                          'Notifications (${controller.unreadCount})',
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111D23),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => controller.markAllAsRead(),
                      child: Text(
                        'Mark all as read',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D631B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const _FilterTabs(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    final tabs = ['All', 'Unread', 'Archived'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(tabs.length, (index) {
          return Obx(() {
            final isSelected = controller.selectedTab == index;
            return Padding(
              padding: EdgeInsets.only(
                right: index == tabs.length - 1 ? 0 : 32,
              ),
              child: GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tabs[index],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF111D23)
                              : const Color(0xFF4C616C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isSelected)
                        Container(
                          height: 4,
                          width: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D631B),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            );
          });
        }),
      ),
    );
  }
}

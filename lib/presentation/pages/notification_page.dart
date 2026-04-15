import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_header.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: Column(
        children: [
          CustomHeader(
            title: 'Notifications',
            onBack: () => Get.back(),
            trailing: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white70,
              size: 26,
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_active_outlined,
                      size: 54,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'No new notifications',
                    style: TextStyle(
                      color: Color(0xFF204B27),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "You're all caught up! Check back later.",
                    style: TextStyle(
                      color: Color(0xFF788A7B),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

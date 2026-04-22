import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/domain/entities/delivery_partner.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/aura_notification_button.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/profile_avatar.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/notification_page/notification_page.dart';
import 'package:flutter_delivery_partner_application/presentation/bindings/notification_binding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.user});
  final DeliveryPartner? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: ProfileAvatar(user: user),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Easy Cater',
                style: GoogleFonts.manrope(
                  color: colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    size: 14,
                    color: colorScheme.tertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '4.9 Star Rating',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        AuraNotificationButton(
          onTap: () => Get.to(
            () => const NotificationPage(),
            binding: NotificationBinding(),
          ),
        ),
      ],
    );
  }
}

// class _WithdrawButton extends StatelessWidget {
//   const _WithdrawButton({required this.onTap});
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return ScaleInteraction(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 52,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(99),
//         ),
//         child: const Center(
//           child: Text(
//             'Withdraw',
//             style: TextStyle(
//               color: Color(0xFF2d8a39),
//               fontWeight: FontWeight.w800,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ViewMoreButton extends StatelessWidget {
//   const _ViewMoreButton({required this.onTap});
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return ScaleInteraction(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 52,
//         decoration: BoxDecoration(
//           color: const Color(0xFF2d8a39),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: const Center(
//           child: Text(
//             'View More',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w800,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// String _initials(String? name) {
//   final trimmed = name?.trim() ?? '';
//   if (trimmed.isEmpty) return 'DP';
//   final parts = trimmed.split(RegExp(r'\s+'));
//   return (parts.first[0] + (parts.length > 1 ? parts[1][0] : '')).toUpperCase();
// }

// class _EmptyDeliveriesIndicator extends StatelessWidget {
//   const _EmptyDeliveriesIndicator();

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 40),
//       decoration: BoxDecoration(
//         color: colorScheme.surfaceContainerLow,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           Icon(
//             Icons.delivery_dining_rounded,
//             color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
//             size: 48,
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'No active deliveries',
//             style: TextStyle(
//               color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

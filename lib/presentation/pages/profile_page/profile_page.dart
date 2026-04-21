import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/profile_controller.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/profile_page/components/availability_toggle.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/profile_page/components/compliance_card.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/profile_page/components/hero_section.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/profile_page/components/profile_page_info_card.dart';
import 'package:flutter_delivery_partner_application/presentation/widgets/connectivity_gate.dart';
import 'package:flutter_delivery_partner_application/presentation/widgets/empty_state.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConnectivityGate(
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline_rounded),
              onPressed: () {},
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value && controller.profile.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final p = controller.profile.value;
          if (p == null) {
            return EmptyState(
              title: 'Profile unavailable',
              subtitle: controller.errorMessage.value.isEmpty
                  ? 'Please try again later.'
                  : controller.errorMessage.value,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                HeroSection(partner: p.deliveryPartner),
                const SizedBox(height: 24),
                AvailabilityToggle(),
                const SizedBox(height: 32),
                ComplianceCard(score: controller.complianceScore.value),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Get.toNamed('personal-details'),
                  child: ProfilePageInfoCard(
                    icon: Icons.person_rounded,
                    title: 'Personal Info',
                    subtitle: p.deliveryPartner.name,
                    content:
                        '${p.deliveryPartner.phoneNumber}\n${p.deliveryPartner.email}',
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ProfilePageInfoCard(
                  icon: Icons.motorcycle_rounded,
                  title: 'Vehicle',
                  subtitle: p.vehicleDetails.vehicleType,
                  content: p.vehicleDetails.vehicleNumber,
                  badgeText: p.vehicleDetails.status.toUpperCase(),
                ),
                const SizedBox(height: 16),
                ProfilePageInfoCard(
                  icon: Icons.account_balance_rounded,
                  title: 'Bank Account',
                  subtitle: p.bankDetails.bankName,
                  content:
                      '•••• •••• ${controller.lastFour(p.bankDetails.accountNumber)}',
                  trailing: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                ProfilePageInfoCard(
                  icon: Icons.description_rounded,
                  title: 'Documents',
                  subtitle:
                      '${p.documents.length}/${p.documents.length} Verified',
                  content: p.documents.map((d) => d.documentType).join(', '),
                  badgeText: 'ALL SET',
                ),
                const SizedBox(height: 48),
                TextButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                  ),
                  label: Text(
                    'Sign Out',
                    style: GoogleFonts.inter(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  controller.appVersion.value,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        }),
      ),
    );
  }
}

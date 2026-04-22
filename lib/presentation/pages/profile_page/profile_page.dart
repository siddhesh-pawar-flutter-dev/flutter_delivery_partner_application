import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/core/utils/app_pages.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/profile_controller.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/profile_page/components/availability_toggle.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/profile_page/components/compliance_card.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/profile_page/components/hero_section.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/profile_page/components/profile_page_info_card.dart';
import 'package:flutter_delivery_partner_application/presentation/widgets/connectivity_gate.dart';
import 'package:flutter_delivery_partner_application/presentation/widgets/empty_state.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConnectivityGate(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F5),
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

          final verifiedDocumentCount = p.documents.where((document) {
            final status = document.status.trim().toLowerCase();
            return status == 'verified' || status == 'approved';
          }).length;
          final allDocumentsVerified =
              verifiedDocumentCount == p.documents.length &&
              p.documents.isNotEmpty;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Profile',
                    style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                HeroSection(partner: p.deliveryPartner),
                const SizedBox(height: 24),
                const AvailabilityToggle(),
                const SizedBox(height: 32),
                ComplianceCard(score: controller.complianceScore.value),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Get.toNamed(AppPages.personalDetails),
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
                  badgeColor: controller.statusColor(p.vehicleDetails.status),
                ),
                const SizedBox(height: 16),
                ProfilePageInfoCard(
                  icon: Icons.account_balance_rounded,
                  title: 'Bank Account',
                  subtitle: p.bankDetails.bankName,
                  content: p.bankDetails.accountNumber.isEmpty
                      ? 'Not provided'
                      : '**** **** ${controller.lastFour(p.bankDetails.accountNumber)}',
                  trailing: p.bankDetails.accountNumber.isEmpty
                      ? null
                      : const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                        ),
                ),
                const SizedBox(height: 16),
                ProfilePageInfoCard(
                  icon: Icons.description_rounded,
                  title: 'Documents',
                  subtitle:
                      '$verifiedDocumentCount/${p.documents.length} Verified',
                  content: p.documents.isEmpty
                      ? 'No documents added'
                      : p.documents.map((d) => d.documentType).join(', '),
                  badgeText: allDocumentsVerified ? 'ALL SET' : 'PENDING',
                  badgeColor: allDocumentsVerified
                      ? Colors.green
                      : Colors.orange,
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

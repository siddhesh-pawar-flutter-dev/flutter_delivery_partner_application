import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/core/utils/app_pages.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/personal_details_page/components/personal_details_info_card.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/personal_details_page/components/personal_details_info_item.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/personal_details_page/components/profile_hero.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/personal_details_page/components/section_header.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/personal_details_page/components/security_tile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/personal_details_controller.dart';

class PersonalDetailsPage extends GetView<PersonalDetailsController> {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Personal Details',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.toNamed(AppPages.editProfile),
            child: Text(
              'Edit',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ),
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
        if (p == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              ProfileHero(
                imageUrl: p.deliveryPartner.profileImage,
                name: p.deliveryPartner.name,
              ),
              const SizedBox(height: 32),
              SectionHeader(title: 'Information', trailing: 'VERIFIED ACCOUNT'),
              const SizedBox(height: 16),
              PersonalDetailsInfoCard(
                items: [
                  PersonalDetailsInfoItem(
                    label: 'Full Name',
                    value: p.deliveryPartner.name,
                    icon: Icons.person_outline_rounded,
                  ),
                  PersonalDetailsInfoItem(
                    label: 'Email Address',
                    value: p.deliveryPartner.email,
                    icon: Icons.mail_outline_rounded,
                  ),
                  PersonalDetailsInfoItem(
                    label: 'Phone Number',
                    value: p.deliveryPartner.phoneNumber,
                    icon: Icons.call_outlined,
                  ),
                  PersonalDetailsInfoItem(
                    label: 'Date of Birth',
                    value: '05/14/1992',
                    icon: Icons.calendar_today_outlined,
                  ),
                  PersonalDetailsInfoItem(
                    label: 'Primary Address',
                    value: '${p.deliveryPartner.city}, NY',
                    icon: Icons.location_on_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SectionHeader(title: 'Account Security'),
              const SizedBox(height: 16),
              SecurityTile(),
              const SizedBox(height: 100),
            ],
          ),
        );
      }),
    );
  }
}

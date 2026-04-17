import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/personal_details_controller.dart';
import '../../../core/utils/app_pages.dart';

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
              _ProfileHero(
                imageUrl: p.deliveryPartner.profileImage,
                name: p.deliveryPartner.name,
              ),
              const SizedBox(height: 32),
              _SectionHeader(
                title: 'Information',
                trailing: 'VERIFIED ACCOUNT',
              ),
              const SizedBox(height: 16),
              _InfoCard(
                items: [
                  _InfoItem(
                    label: 'Full Name',
                    value: p.deliveryPartner.name,
                    icon: Icons.person_outline_rounded,
                  ),
                  _InfoItem(
                    label: 'Email Address',
                    value: p.deliveryPartner.email,
                    icon: Icons.mail_outline_rounded,
                  ),
                  _InfoItem(
                    label: 'Phone Number',
                    value: p.deliveryPartner.phoneNumber,
                    icon: Icons.call_outlined,
                  ),
                  _InfoItem(
                    label: 'Date of Birth',
                    value: '05/14/1992',
                    icon: Icons.calendar_today_outlined,
                  ),
                  _InfoItem(
                    label: 'Primary Address',
                    value: '${p.deliveryPartner.city}, NY',
                    icon: Icons.location_on_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _SectionHeader(title: 'Account Security'),
              const SizedBox(height: 16),
              _SecurityTile(),
              const SizedBox(height: 100), // Space for bottom dock
            ],
          ),
        );
      }),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.imageUrl, required this.name});
  final String imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 128,
              height: 128,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(64),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover)
                    : Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: colorScheme.primary,
                        ),
                      ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'Logistics Navigator • Level 4',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});
  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colorScheme.secondary,
              letterSpacing: 1.2,
            ),
          ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.items});
  final List<_InfoItem> items;

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

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: colorScheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(icon, size: 20, color: colorScheme.outlineVariant),
          ],
        ),
      ],
    );
  }
}

class _SecurityTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_rounded,
              size: 20,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password & Security',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Last changed 3 months ago',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: colorScheme.secondary),
        ],
      ),
    );
  }
}

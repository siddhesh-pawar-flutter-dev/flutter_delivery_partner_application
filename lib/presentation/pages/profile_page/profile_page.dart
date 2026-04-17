import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/entities/delivery_partner.dart';
import '../../controllers/profile_controller.dart';
import '../../widgets/connectivity_gate.dart';
import '../../widgets/empty_state.dart';

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
                _HeroSection(partner: p.deliveryPartner),
                const SizedBox(height: 24),
                _AvailabilityToggle(),
                const SizedBox(height: 32),
                _ComplianceCard(score: controller.complianceScore.value),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Get.toNamed('personal-details'),
                  child: _InfoCard(
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
                _InfoCard(
                  icon: Icons.motorcycle_rounded,
                  title: 'Vehicle',
                  subtitle: p.vehicleDetails.vehicleType,
                  content: p.vehicleDetails.vehicleNumber,
                  badgeText: p.vehicleDetails.status.toUpperCase(),
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  icon: Icons.account_balance_rounded,
                  title: 'Bank Account',
                  subtitle: p.bankDetails.bankName,
                  content:
                      '•••• •••• ${_lastFour(p.bankDetails.accountNumber)}',
                  trailing: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoCard(
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
                const SizedBox(height: 100), // Space for floating dock
              ],
            ),
          );
        }),
      ),
    );
  }

  String _lastFour(String acc) {
    if (acc.length < 4) return acc;
    return acc.substring(acc.length - 4);
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.partner});
  final DeliveryPartner partner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: partner.profileImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: partner.profileImage,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.person_rounded,
                          size: 60,
                          color: colorScheme.primary,
                        ),
                      ),
              ),
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_rounded,
                  size: 24,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          partner.name.isEmpty ? 'Delivery Partner' : partner.name,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    partner.avgRating.toStringAsFixed(1),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '•  Delivery Partner',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AvailabilityToggle extends GetView<ProfileController> {
  const _AvailabilityToggle();
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      final isOnline = controller.isOnline.value;
      return Container(
        height: 52,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            // Sliding Indicator
            AnimatedAlign(
              duration: const Duration(milliseconds: 750),
              curve:
                  Curves.easeInOutBack, // Gives a slight "bounce" to the slide
              alignment: isOnline
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: (isOnline ? Colors.green : Colors.red).withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: (isOnline ? Colors.green : Colors.red).withValues(
                        alpha: 0.4,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isOnline ? Colors.green : Colors.red)
                            .withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Interaction Layer
            Row(
              children: [
                Expanded(
                  child: _ToggleButton(
                    label: 'Online',
                    isSelected: isOnline,
                    activeColor: Colors.green,
                    onTap: () {
                      if (!isOnline) controller.toggleOnline();
                    },
                  ),
                ),
                Expanded(
                  child: _ToggleButton(
                    label: 'Offline',
                    isSelected: !isOnline,
                    activeColor: Colors.red,
                    onTap: () {
                      if (isOnline) controller.toggleOnline();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? activeColor : colorScheme.onSurfaceVariant,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

class _ComplianceCard extends StatelessWidget {
  const _ComplianceCard({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Compliance Score', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  score >= 90
                      ? 'Great work! You\'re in the top 5% of elite navigators.'
                      : 'Keep it up! Complete more details to improve your score.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 8,
                  backgroundColor: colorScheme.surfaceContainerLow,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '$score%',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.content,
    this.trailing,
    this.badgeText,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String content;
  final Widget? trailing;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Expanded(child: SizedBox()),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeText!,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

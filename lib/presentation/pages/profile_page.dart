import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/profile_details.dart';
import '../controllers/profile_controller.dart';
import '../widgets/connectivity_gate.dart';
import '../widgets/empty_state.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityGate(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F5),
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value &&
                controller.profile.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.value.isNotEmpty &&
                controller.profile.value == null) {
              return EmptyState(
                title: 'Unable to load profile',
                subtitle: controller.errorMessage.value,
              );
            }

            final profile = controller.profile.value;
            if (profile == null) {
              return const EmptyState(
                title: 'Profile unavailable',
                subtitle: 'Please try again in a moment.',
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF4CAF50),
              onRefresh: controller.loadProfile,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 28),
                children: [
                  _TopHeader(title: 'Account'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                    child: _ProfileHero(profile: profile),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(18, 18, 18, 10),
                    child: Text(
                      'Options',
                      style: TextStyle(
                        color: Color(0xFF2F2F2F),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        _OptionTile(
                          icon: Icons.person_outline_rounded,
                          label: 'Edit Profile',
                          onTap: _comingSoon,
                        ),
                        _OptionTile(
                          icon: Icons.location_on_outlined,
                          label: 'Allotted Area',
                          onTap: () => _showInfo(
                            'Allotted Area',
                            _allottedArea(profile),
                          ),
                        ),
                        _OptionTile(
                          icon: Icons.card_giftcard_rounded,
                          label: 'Refer and Earn',
                          onTap: _comingSoon,
                        ),
                        _OptionTile(
                          icon: Icons.headset_mic_outlined,
                          label: 'Support',
                          onTap: () => _showInfo(
                            'Support',
                            'For support, please contact the Easy Cater team.',
                          ),
                        ),
                        _OptionTile(
                          icon: Icons.quiz_outlined,
                          label: 'FAQ',
                          onTap: _comingSoon,
                        ),
                        _OptionTile(
                          icon: Icons.description_outlined,
                          label: 'Terms and Conditions',
                          onTap: _comingSoon,
                        ),
                        _OptionTile(
                          icon: Icons.remove_red_eye_outlined,
                          label: 'Privacy Policy',
                          onTap: _comingSoon,
                        ),
                        _OptionTile(
                          icon: Icons.calendar_month_outlined,
                          label: 'Ask For Leave',
                          onTap: _comingSoon,
                        ),
                        _OptionTile(
                          icon: Icons.logout_rounded,
                          label: 'Log Out',
                          isDestructive: true,
                          onTap: controller.logout,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Obx(
                    () => Center(
                      child: Text(
                        controller.appVersion.value,
                        style: const TextStyle(
                          color: Color(0xFFC6C6CC),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),

      ),
    );
  }

  void _comingSoon() {
    Get.snackbar(
      'Coming soon',
      'This section is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  String _allottedArea(ProfileDetails profile) {
    final city = profile.deliveryPartner.city.trim();
    final state = profile.deliveryPartner.state.trim();
    if (city.isNotEmpty && state.isNotEmpty) {
      return '$city, $state';
    }
    if (city.isNotEmpty) return city;
    if (state.isNotEmpty) return state;
    return 'No allotted area available in the current profile data.';
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFAAF0B7), Color(0xFF4CAF50)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});

  final ProfileDetails profile;

  @override
  Widget build(BuildContext context) {
    final partner = profile.deliveryPartner;
    final imageUrl = partner.profileImage.trim();
    final rating = partner.totalRatings == 0
        ? '--'
        : partner.avgRating.toStringAsFixed(1);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 72,
          height: 72,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF4CAF50), width: 2),
          ),
          child: ClipOval(
            child: imageUrl.isEmpty
                ? _AvatarFallback(name: partner.name)
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 180,
                    maxWidthDiskCache: 220,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    errorWidget: (_, _, _) =>
                        _AvatarFallback(name: partner.name),
                  ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 18,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      partner.name.isEmpty ? 'Delivery Partner' : partner.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF434343),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rating,
                          style: const TextStyle(
                            color: Color(0xFF474747),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Color(0xFF4CAF50),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _ContactRow(
                icon: Icons.call_outlined,
                text: '${partner.countryCode} ${partner.phoneNumber}'.trim(),
              ),
              const SizedBox(height: 8),
              _ContactRow(icon: Icons.email_outlined, text: partner.email),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFor(name);
    return Container(
      color: const Color(0xFF4CAF50),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF4CAF50)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.isEmpty ? '--' : text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF66666D),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final accent = isDestructive
        ? const Color(0xFFFF5E67)
        : const Color(0xFF2E7D32);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: accent),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: accent,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


String _initialsFor(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return 'DP';
  final parts = trimmed.split(RegExp(r'\s+'));
  final first = parts.first.isNotEmpty ? parts.first[0] : '';
  final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
  return (first + second).toUpperCase();
}

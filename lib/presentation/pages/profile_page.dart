import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../widgets/connectivity_gate.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_card.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return ConnectivityGate(
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(() {
              if (controller.isLoading.value && controller.profile.value == null) {
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
                onRefresh: controller.loadProfile,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SectionCard(
                      title: 'Personal Details',
                      children: [
                        _InfoRow(label: 'Name', value: profile.deliveryPartner.name),
                        _InfoRow(label: 'Email', value: profile.deliveryPartner.email),
                        _InfoRow(
                          label: 'Phone',
                          value:
                              '${profile.deliveryPartner.countryCode} ${profile.deliveryPartner.phoneNumber}',
                        ),
                        _InfoRow(label: 'Status', value: profile.deliveryPartner.status),
                      ],
                    ),
                    SectionCard(
                      title: 'Vehicle',
                      children: [
                        _InfoRow(label: 'Type', value: profile.vehicleDetails.vehicleType),
                        _InfoRow(
                          label: 'Number',
                          value: profile.vehicleDetails.vehicleNumber,
                        ),
                        _InfoRow(label: 'Status', value: profile.vehicleDetails.status),
                      ],
                    ),
                    SectionCard(
                      title: 'Bank',
                      children: [
                        _InfoRow(label: 'Bank', value: profile.bankDetails.bankName),
                        _InfoRow(
                          label: 'Account',
                          value: profile.bankDetails.accountNumber,
                        ),
                        _InfoRow(label: 'IFSC', value: profile.bankDetails.ifscCode),
                      ],
                    ),
                    SectionCard(
                      title: 'Documents',
                      children:
                          profile.documents
                              .map(
                                (document) => _InfoRow(
                                  label: document.documentType,
                                  value: '${document.documentNumber} • ${document.status}',
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/formatters.dart';
import '../controllers/gig_by_date_controller.dart';
import '../widgets/custom_header.dart';
import '../widgets/empty_state.dart';

class GigByDatePage extends GetView<GigByDateController> {
  const GigByDatePage({super.key});

  String _formatDate(String dateString) {
    try {
      final parsed = DateTime.parse(dateString);
      return Formatters.formatDateTime(parsed, format: 'dd/MM/yyyy');
    } catch (_) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = _formatDate(controller.date);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: Column(
        children: [
            CustomHeader(
              title: 'Slots for $displayDate',
              subtitle: 'Select a slot to start earning',
              onBack: () => Get.back(),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${controller.gigs.length} available',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.gigs.isEmpty) {
                  return Center(
                    child: EmptyState(
                      title: 'Failed to load gigs',
                      subtitle: controller.errorMessage.value,
                    ),
                  );
                }

                if (controller.gigs.isEmpty) {
                  return Center(
                    child: EmptyState(
                      title: 'No slots available',
                      subtitle: 'There are no gig slots on $displayDate.',
                    ),
                  );
                }

                return RefreshIndicator(
                  color: const Color(0xFF4CAF50),
                  onRefresh: controller.loadInitialData,
                  child: ListView.separated(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 80, // Padding for bottom navbar just in case
                    ),
                    itemCount: controller.gigs.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == controller.gigs.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        );
                      }
                      
                      final gig = controller.gigs[index];
                      return _GigSlotCard(
                        slotId: gig.slotId,
                        slotStartHour: gig.slotStartHour,
                        slotEndHour: gig.slotEndHour,
                        estimatedPayout: gig.estimatedPayout,
                        neededPeople: gig.neededPeople,
                        enrolledPeople: gig.enrolledPeople,
                        percentageForComplete: gig.percentageForComplete,
                        status: gig.historyStatus,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
    );
  }
}

class _GigSlotCard extends StatelessWidget {
  const _GigSlotCard({
    required this.slotId,
    required this.slotStartHour,
    required this.slotEndHour,
    required this.estimatedPayout,
    required this.neededPeople,
    required this.enrolledPeople,
    required this.percentageForComplete,
    required this.status,
  });

  final String slotId;
  final String slotStartHour;
  final String slotEndHour;
  final String estimatedPayout;
  final int neededPeople;
  final int enrolledPeople;
  final double percentageForComplete;
  final String? status;

  Color _getStatusColor(String? statusText) {
    if (statusText == null || statusText.isEmpty) {
      return const Color(0xFF2E7D32); // Available slot color
    }
    
    final lowerStatus = statusText.toLowerCase();
    if (lowerStatus == 'complete' || lowerStatus == 'completed') {
      return const Color(0xFF4CAF50);
    } else if (lowerStatus == 'enrolled') {
      return const Color(0xFFFF9800);
    }
    return const Color(0xFF434343);
  }

  String _getDisplayStatus() {
    if (status == null || status!.isEmpty) {
      return 'AVAILABLE';
    }
    return status!.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);
    final displayStatus = _getDisplayStatus();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Future enrollment logic
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: statusColor.withValues(alpha: 0.05),
          highlightColor: statusColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.access_time_rounded, size: 20, color: statusColor),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$slotStartHour - $slotEndHour',
                          style: const TextStyle(
                            color: Color(0xFF2F2F2F),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        displayStatus,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        label: 'Estimated Payout',
                        value: '₹$estimatedPayout',
                        icon: Icons.payments_rounded,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        label: 'Available Slots',
                        value: '${neededPeople - enrolledPeople}',
                        icon: Icons.group_rounded,
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF8E8E8E),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

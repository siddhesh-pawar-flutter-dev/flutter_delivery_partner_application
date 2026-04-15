import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/utils/app_pages.dart';
import '../controllers/gig_history_controller.dart';
import '../widgets/custom_header.dart';
import '../widgets/empty_state.dart';

class GigHistoryPage extends GetView<GigHistoryController> {
  const GigHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: Column(
        children: [
          CustomHeader(
            title: 'Gig History',
            subtitle: 'Your performance and records',
            trailing: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: Colors.white,
                size: 28,
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
                return const Center(
                  child: EmptyState(
                    title: 'No Gig History',
                    subtitle: 'You have not completed any gigs yet.',
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
                    bottom: 80, // Padding for bottom navbar
                  ),
                  itemCount:
                      controller.gigs.length +
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
                    return _GigCard(
                      date: gig.date,
                      status: gig.status,
                      completed: gig.totalCompleted,
                      rejected: gig.totalRejected,
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

class _GigCard extends StatelessWidget {
  const _GigCard({
    required this.date,
    required this.status,
    required this.completed,
    required this.rejected,
  });

  final String date;
  final String status;
  final int completed;
  final int rejected;

  String _formatDate(String dateString) {
    try {
      final parsed = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return dateString;
    }
  }

  Color _getStatusColor(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'complete' || lowerStatus == 'completed') {
      return const Color(0xFF4CAF50);
    } else if (lowerStatus == 'enrolled') {
      return const Color(0xFFFF9800);
    }
    return const Color(0xFF434343);
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(date);
    final statusColor = _getStatusColor(status);

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
            Get.toNamed(
              AppPages.gigByDate,
              arguments: {'date': date},
            );
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
                          child: Icon(Icons.calendar_month_rounded, size: 20, color: statusColor),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          formattedDate,
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
                        status.toUpperCase(),
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
                        label: 'Completed',
                        value: completed.toString(),
                        icon: Icons.check_circle_rounded,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        label: 'Rejected',
                        value: rejected.toString(),
                        icon: Icons.cancel_rounded,
                        color: const Color(0xFFFF5E67),
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

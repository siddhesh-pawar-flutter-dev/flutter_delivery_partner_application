import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controllers/gig_history_controller.dart';
import '../../widgets/connectivity_gate.dart';
import '../../widgets/empty_state.dart';
import '../../../core/utils/app_pages.dart';

class GigHistoryPage extends GetView<GigHistoryController> {
  const GigHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConnectivityGate(
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F6F2),
        // appBar: AppBar(
        //   backgroundColor: const Color(0xFFF1F6F2),
        //   elevation: 0,
        //   title: const Text(
        //     'Earnings',
        //     style: TextStyle(
        //       color: Color(0xFF2E7D32),
        //       fontSize: 18,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: Obx(() {
            final gigs = controller.gigs;

            if (controller.isLoading.value && gigs.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF2E7D32),
              onRefresh: controller.loadInitialData,
              child: ListView(
                controller: controller.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 24),

                  Text(
                    'Gig History',
                    style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    'PERFORMANCE OVERVIEW',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.black38,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _PerformanceOverview(gigs: gigs),
                  const SizedBox(height: 32),

                  if (gigs.isEmpty)
                    const EmptyState(
                      title: 'No Gig History',
                      subtitle: 'Start your first shift!',
                    )
                  else ...[
                    _HistorySection(
                      title: 'This Week',
                      gigs: gigs.take(3).toList(),
                    ),
                    const SizedBox(height: 16),
                    _HistorySection(
                      title: 'Last Week',
                      gigs: gigs.skip(3).toList(),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _PerformanceOverview extends StatelessWidget {
  const _PerformanceOverview({required this.gigs});
  final List<dynamic> gigs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.stars_rounded, color: Colors.white38, size: 28),
              const SizedBox(height: 12),
              Text(
                'Success Rate',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              Text(
                '98.4%',
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.trending_up_rounded,
                label: 'Total Earnings',
                value: 'Rs 42,800',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _MetricCard(
                icon: Icons.access_time_filled_rounded,
                label: 'Active Hours',
                value: '142h',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 20),
          const SizedBox(height: 16),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black38,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.title, required this.gigs});
  final String title;
  final List<dynamic> gigs;

  @override
  Widget build(BuildContext context) {
    if (gigs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ),
        ...gigs.map((gig) => _GigCard(gig: gig)),
      ],
    );
  }
}

class _GigCard extends StatelessWidget {
  const _GigCard({required this.gig});
  final dynamic gig;

  String _formatDate(String dateString) {
    try {
      final parsed = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(parsed);
    } catch (_) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppPages.gigByDate, arguments: {'date': gig.date}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(gig.date),
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _StatusBadge(status: gig.status),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Daily Earnings',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black38,
                      ),
                    ),
                    Text(
                      'Rs 1,425.00',
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _MiniMetric(
                    label: 'COMPLETED',
                    value: '${gig.totalCompleted} Gigs',
                    icon: Icons.check_circle_rounded,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniMetric(
                    label: 'REJECTED',
                    value:
                        '${gig.totalRejected} ${gig.totalRejected == 1 ? "Gig" : "Gigs"}',
                    icon: Icons.cancel_rounded,
                    color: const Color(0xFFD32F2F),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase();
    Color bgColor = const Color(0xFFC8E6C9);
    Color textColor = const Color(0xFF2E7D32);
    String label = 'COMPLETED';

    if (lower.contains('partial')) {
      bgColor = const Color(0xFFFCE4EC);
      textColor = const Color(0xFFC2185B);
      label = 'PARTIAL';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: color.withValues(alpha: 0.6),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

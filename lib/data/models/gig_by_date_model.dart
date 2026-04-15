import '../../core/utils/formatters.dart';
import '../../domain/entities/gig_by_date.dart';

class GigByDateItemModel extends GigByDateItem {
  const GigByDateItemModel({
    required super.gigId,
    required super.slotId,
    required super.slotHours,
    required super.slotStartHour,
    required super.slotEndHour,
    required super.estimatedPayout,
    required super.neededPeople,
    required super.enrolledPeople,
    required super.date,
    required super.percentageForComplete,
    required super.historyStatus,
    required super.historyTotalCompleted,
    required super.historyTotalRejected,
  });

  factory GigByDateItemModel.fromJson(Map<String, dynamic> json) {
    final historyInfo = json['GigsHistory'] as Map<String, dynamic>?;

    return GigByDateItemModel(
      gigId: Formatters.parseInt(json['gig_id']),
      slotId: (json['slot_id'] ?? '').toString(),
      slotHours: (json['slot_hours'] ?? '').toString(),
      slotStartHour: (json['slot_start_hour'] ?? '').toString(),
      slotEndHour: (json['slot_end_hour'] ?? '').toString(),
      estimatedPayout: (json['estimated_payout'] ?? '').toString(),
      neededPeople: Formatters.parseInt(json['needed_people']),
      enrolledPeople: Formatters.parseInt(json['enrolled_people']),
      date: (json['date'] ?? '').toString(),
      percentageForComplete: Formatters.parseAmount(json['percentage_for_complete']),
      historyStatus: historyInfo?['status']?.toString(),
      historyTotalCompleted: Formatters.parseInt(historyInfo?['total_completed']),
      historyTotalRejected: Formatters.parseInt(historyInfo?['total_rejectd']),
    );
  }
}

class GigByDatePageModel extends GigByDatePageData {
  const GigByDatePageModel({
    required super.gigs,
    required super.currentPage,
    required super.totalPages,
    required super.totalItems,
  });

  factory GigByDatePageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final gigsJson = data['data'] as List<dynamic>? ?? [];
    final pagination = data['pagination'] as Map<String, dynamic>? ?? {};

    return GigByDatePageModel(
      gigs: gigsJson
          .map((item) =>
              GigByDateItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: Formatters.parseInt(pagination['currentPage']),
      totalPages: Formatters.parseInt(pagination['totalPages']),
      totalItems: Formatters.parseInt(pagination['total']),
    );
  }
}

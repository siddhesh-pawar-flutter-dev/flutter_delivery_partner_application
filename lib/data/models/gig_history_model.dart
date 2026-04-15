import '../../core/utils/formatters.dart';
import '../../domain/entities/gig_history.dart';

class GigHistoryItemModel extends GigHistoryItem {
  const GigHistoryItemModel({
    required super.date,
    required super.status,
    required super.totalRejected,
    required super.totalCompleted,
  });

  factory GigHistoryItemModel.fromJson(Map<String, dynamic> json) {
    final historyInfo = json['GigsHistory'] as Map<String, dynamic>? ?? {};
    
    return GigHistoryItemModel(
      date: (json['date'] ?? '').toString(),
      status: (historyInfo['status'] ?? '').toString(),
      totalRejected: Formatters.parseInt(historyInfo['total_rejectd']),
      totalCompleted: Formatters.parseInt(historyInfo['total_completed']),
    );
  }
}

class GigHistoryPageModel extends GigHistoryPageData {
  const GigHistoryPageModel({
    required super.gigs,
    required super.currentPage,
    required super.totalPages,
    required super.totalItems,
  });

  factory GigHistoryPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final gigsJson = data['gigs'] as List<dynamic>? ?? [];
    final pagination = data['pagination'] as Map<String, dynamic>? ?? {};

    return GigHistoryPageModel(
      gigs: gigsJson
          .map((item) => GigHistoryItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: Formatters.parseInt(pagination['currentPage']),
      totalPages: Formatters.parseInt(pagination['totalPages']),
      totalItems: Formatters.parseInt(pagination['totalItems']),
    );
  }
}

class GigByDateItem {
  const GigByDateItem({
    required this.gigId,
    required this.slotId,
    required this.slotHours,
    required this.slotStartHour,
    required this.slotEndHour,
    required this.estimatedPayout,
    required this.neededPeople,
    required this.enrolledPeople,
    required this.date,
    required this.percentageForComplete,
    required this.historyStatus,
    required this.historyTotalCompleted,
    required this.historyTotalRejected,
  });

  final int gigId;
  final String slotId;
  final String slotHours;
  final String slotStartHour;
  final String slotEndHour;
  final String estimatedPayout;
  final int neededPeople;
  final int enrolledPeople;
  final String date;
  final double percentageForComplete;
  final String? historyStatus;
  final int historyTotalCompleted;
  final int historyTotalRejected;
}

class GigByDatePageData {
  const GigByDatePageData({
    required this.gigs,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  final List<GigByDateItem> gigs;
  final int currentPage;
  final int totalPages;
  final int totalItems;
}

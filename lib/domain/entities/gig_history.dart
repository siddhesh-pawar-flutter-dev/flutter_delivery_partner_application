class GigHistoryItem {
  const GigHistoryItem({
    required this.date,
    required this.status,
    required this.totalRejected,
    required this.totalCompleted,
  });

  final String date;
  final String status;
  final int totalRejected;
  final int totalCompleted;
}

class GigHistoryPageData {
  const GigHistoryPageData({
    required this.gigs,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  final List<GigHistoryItem> gigs;
  final int currentPage;
  final int totalPages;
  final int totalItems;
}

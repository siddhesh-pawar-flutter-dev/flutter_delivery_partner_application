import '../entities/gig_by_date.dart';
import '../entities/gig_history.dart';

abstract class GigRepository {
  Future<GigHistoryPageData> getGigHistory({
    required int page,
    required int limit,
  });

  Future<GigByDatePageData> getGigByDate({
    required int page,
    required int limit,
    required String selectedDate,
  });
}

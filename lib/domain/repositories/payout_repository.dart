import '../entities/payout.dart';

abstract class PayoutRepository {
  Future<PayoutPageData> getPayoutHistory({
    required int page,
    required int limit,
  });
}

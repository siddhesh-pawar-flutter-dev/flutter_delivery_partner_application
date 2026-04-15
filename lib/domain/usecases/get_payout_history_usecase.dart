import '../entities/payout.dart';
import '../repositories/payout_repository.dart';

class GetPayoutHistoryUseCase {
  const GetPayoutHistoryUseCase(this._repository);

  final PayoutRepository _repository;

  Future<PayoutPageData> execute({int page = 1, int limit = 10}) {
    return _repository.getPayoutHistory(page: page, limit: limit);
  }
}

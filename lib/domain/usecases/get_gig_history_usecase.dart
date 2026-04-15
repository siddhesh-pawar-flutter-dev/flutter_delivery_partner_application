import '../entities/gig_history.dart';
import '../repositories/gig_repository.dart';

class GetGigHistoryUseCase {
  const GetGigHistoryUseCase(this._repository);

  final GigRepository _repository;

  Future<GigHistoryPageData> execute({int page = 1, int limit = 10}) {
    return _repository.getGigHistory(page: page, limit: limit);
  }
}

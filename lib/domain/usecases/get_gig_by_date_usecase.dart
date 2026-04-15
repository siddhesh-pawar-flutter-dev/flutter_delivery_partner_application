import '../entities/gig_by_date.dart';
import '../repositories/gig_repository.dart';

class GetGigByDateUseCase {
  const GetGigByDateUseCase(this._repository);

  final GigRepository _repository;

  Future<GigByDatePageData> execute({required String selectedDate, int page = 1, int limit = 10}) {
    return _repository.getGigByDate(page: page, limit: limit, selectedDate: selectedDate);
  }
}

import '../../domain/entities/gig_by_date.dart';
import '../../domain/entities/gig_history.dart';
import '../../domain/repositories/gig_repository.dart';
import '../datasources/gig_remote_data_source.dart';
import '../models/gig_by_date_model.dart';
import '../models/gig_history_model.dart';

class GigRepositoryImpl implements GigRepository {
  GigRepositoryImpl(this._remoteDataSource);

  final GigRemoteDataSource _remoteDataSource;

  @override
  Future<GigHistoryPageData> getGigHistory({
    required int page,
    required int limit,
  }) async {
    final response = await _remoteDataSource.getGigHistory(
      page: page,
      limit: limit,
    );
    
    return GigHistoryPageModel.fromJson(response);
  }

  @override
  Future<GigByDatePageData> getGigByDate({
    required int page,
    required int limit,
    required String selectedDate,
  }) async {
    final response = await _remoteDataSource.getGigByDate(
      page: page,
      limit: limit,
      selectedDate: selectedDate,
    );
    
    return GigByDatePageModel.fromJson(response);
  }
}

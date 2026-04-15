import '../../domain/entities/payout.dart';
import '../../domain/repositories/payout_repository.dart';
import '../datasources/payout_remote_data_source.dart';
import '../models/payout_model.dart';

class PayoutRepositoryImpl implements PayoutRepository {
  PayoutRepositoryImpl(this._remoteDataSource);

  final PayoutRemoteDataSource _remoteDataSource;

  @override
  Future<PayoutPageData> getPayoutHistory({
    required int page,
    required int limit,
  }) async {
    final response = await _remoteDataSource.getPayoutHistory(
      page: page,
      limit: limit,
    );
    
    return PayoutPageModel.fromJson(response);
  }
}

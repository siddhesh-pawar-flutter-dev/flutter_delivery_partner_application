import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/profile_details.dart';
import '../../domain/repositories/partner_repository.dart';
import '../datasources/partner_remote_data_source.dart';

class PartnerRepositoryImpl implements PartnerRepository {
  PartnerRepositoryImpl(this._remoteDataSource);

  final PartnerRemoteDataSource _remoteDataSource;

  @override
  Future<ProfileDetails> getProfileDetails() async {
    try {
      return await _remoteDataSource.getProfileDetails();
    } on AppException catch (error) {
      throw ServerFailure(error.message);
    }
  }
}

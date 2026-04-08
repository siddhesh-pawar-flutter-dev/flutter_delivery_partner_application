import '../entities/profile_details.dart';
import '../repositories/partner_repository.dart';

class GetProfileUseCase {
  GetProfileUseCase(this._repository);

  final PartnerRepository _repository;

  Future<ProfileDetails> call() => _repository.getProfileDetails();
}

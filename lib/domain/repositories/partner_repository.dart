import '../entities/profile_details.dart';

abstract class PartnerRepository {
  Future<ProfileDetails> getProfileDetails();
}

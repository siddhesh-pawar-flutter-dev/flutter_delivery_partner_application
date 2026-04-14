import '../entities/profile_details.dart';

abstract class PartnerRepository {
  Future<ProfileDetails> getProfileDetails();
  Future<Map<String, dynamic>> updateOnlineStatus(bool isOnline);
}

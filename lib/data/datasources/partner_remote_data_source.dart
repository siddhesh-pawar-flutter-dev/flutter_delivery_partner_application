import '../../core/network/api_client.dart';
import '../../core/utils/app_constants.dart';
import '../models/profile_details_model.dart';

abstract class PartnerRemoteDataSource {
  Future<ProfileDetailsModel> getProfileDetails();
}

class PartnerRemoteDataSourceImpl implements PartnerRemoteDataSource {
  PartnerRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ProfileDetailsModel> getProfileDetails() async {
    final response = await _apiClient.get(AppConstants.profile);
    return ProfileDetailsModel.fromJson(response.data as Map<String, dynamic>);
  }
}

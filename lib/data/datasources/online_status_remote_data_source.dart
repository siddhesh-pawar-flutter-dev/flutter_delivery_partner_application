import '../../core/network/api_client.dart';
import '../../core/utils/app_constants.dart';

abstract class OnlineStatusRemoteDataSource {
  Future<Map<String, dynamic>> updateOnlineStatus(bool isOnline);
}

class OnlineStatusRemoteDataSourceImpl implements OnlineStatusRemoteDataSource {
  OnlineStatusRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Map<String, dynamic>> updateOnlineStatus(bool isOnline) async {
    final response = await _apiClient.patch(
      AppConstants.onlineStatus,
      data: {'status': isOnline},
    );
    return response.data as Map<String, dynamic>;
  }
}
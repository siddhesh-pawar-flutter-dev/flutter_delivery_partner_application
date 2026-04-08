import '../../core/network/api_client.dart';
import '../../core/utils/app_constants.dart';
import '../models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp({
    required String countryCode,
    required String phone,
  });

  Future<AuthSessionModel> verifyOtp({
    required String otp,
    required String countryCode,
    required String phone,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<void> sendOtp({
    required String countryCode,
    required String phone,
  }) async {
    await _apiClient.post(
      AppConstants.sendOtp,
      data: {
        'country_code': countryCode,
        'phone': phone,
        'type': 'login',
        'user_type': 'delivery_partner',
      },
    );
  }

  @override
  Future<AuthSessionModel> verifyOtp({
    required String otp,
    required String countryCode,
    required String phone,
  }) async {
    final response = await _apiClient.post(
      AppConstants.verifyOtp,
      data: {
        'otp': otp,
        'country_code': countryCode,
        'phone': phone,
        'device_token': 'demo-device-token',
        'device_type': 'android',
        'device_id': 'demo-device-id',
      },
    );
    return AuthSessionModel.fromJson(response.data as Map<String, dynamic>);
  }
}

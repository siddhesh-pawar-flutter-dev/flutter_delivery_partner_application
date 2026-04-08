import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/utils/storage_service.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/delivery_partner.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/delivery_partner_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required StorageService storageService,
  }) : _remoteDataSource = remoteDataSource,
       _storageService = storageService;

  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _storageService;

  @override
  Future<void> sendOtp({
    required String countryCode,
    required String phone,
  }) async {
    try {
      await _remoteDataSource.sendOtp(countryCode: countryCode, phone: phone);
    } on AppException catch (error) {
      throw ServerFailure(error.message);
    }
  }

  @override
  Future<AuthSession> verifyOtp({
    required String otp,
    required String countryCode,
    required String phone,
  }) async {
    try {
      final session = await _remoteDataSource.verifyOtp(
        otp: otp,
        countryCode: countryCode,
        phone: phone,
      );
      await _storageService.saveToken(session.token);
      await _storageService.saveUser(
        session.deliveryPartner as DeliveryPartnerModel,
      );
      return session;
    } on AppException catch (error) {
      throw ServerFailure(error.message);
    }
  }

  @override
  String getSavedLanguage() => _storageService.selectedLanguage;

  @override
  DeliveryPartner? getSavedUser() => _storageService.getUser();

  @override
  bool isLoggedIn() {
    final token = _storageService.token;
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> saveLanguage(String language) {
    return _storageService.saveLanguage(language);
  }
}

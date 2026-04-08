import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call({
    required String otp,
    required String countryCode,
    required String phone,
  }) {
    return _repository.verifyOtp(
      otp: otp,
      countryCode: countryCode,
      phone: phone,
    );
  }
}

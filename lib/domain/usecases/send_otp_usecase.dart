import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  SendOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String countryCode,
    required String phone,
  }) {
    return _repository.sendOtp(countryCode: countryCode, phone: phone);
  }
}

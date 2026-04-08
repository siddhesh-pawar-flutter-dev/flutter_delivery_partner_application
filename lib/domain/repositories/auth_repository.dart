import '../entities/auth_session.dart';
import '../entities/delivery_partner.dart';

abstract class AuthRepository {
  Future<void> sendOtp({
    required String countryCode,
    required String phone,
  });

  Future<AuthSession> verifyOtp({
    required String otp,
    required String countryCode,
    required String phone,
  });

  Future<void> saveLanguage(String language);

  String getSavedLanguage();

  DeliveryPartner? getSavedUser();

  bool isLoggedIn();
}

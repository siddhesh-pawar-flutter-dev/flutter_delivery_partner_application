import '../../domain/entities/auth_session.dart';
import 'delivery_partner_model.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.token,
    required DeliveryPartnerModel super.deliveryPartner,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return AuthSessionModel(
      token: (data['token'] ?? '').toString(),
      deliveryPartner: DeliveryPartnerModel.fromJson(
        data['deliveryPartner'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

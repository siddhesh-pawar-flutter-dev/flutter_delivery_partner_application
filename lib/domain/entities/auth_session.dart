import 'delivery_partner.dart';

class AuthSession {
  const AuthSession({
    required this.token,
    required this.deliveryPartner,
  });

  final String token;
  final DeliveryPartner deliveryPartner;
}

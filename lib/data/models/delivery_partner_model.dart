import '../../core/utils/formatters.dart';
import '../../domain/entities/delivery_partner.dart';

class DeliveryPartnerModel extends DeliveryPartner {
  const DeliveryPartnerModel({
    required super.id,
    required super.name,
    required super.email,
    required super.countryCode,
    required super.phoneNumber,
    required super.language,
    required super.status,
    required super.profileImage,
    required super.city,
    required super.state,
    required super.totalDeductionBalance,
    required super.avgRating,
    required super.totalRatings,
    required super.canOnline,
    required super.termToggle,
    required super.isTshirtPicked,
  });

  factory DeliveryPartnerModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPartnerModel(
      id: Formatters.parseInt(json['delivery_id']),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      countryCode: (json['country_code'] ?? '').toString(),
      phoneNumber: (json['phone_number'] ?? json['phone'] ?? '').toString(),
      language: (json['language'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      profileImage: Formatters.sanitizeUrl(json['profile_image']?.toString()),
      city: (json['city'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      totalDeductionBalance: Formatters.parseAmount(
        json['total_deduction_balance'],
      ),
      avgRating: Formatters.parseAmount(json['avg_rating']),
      totalRatings: Formatters.parseInt(json['total_ratings']),
      canOnline: json['can_online'] == 1 || json['can_online'] == true,
      termToggle: json['term_toggle'] == 1 || json['term_toggle'] == true,
      isTshirtPicked:
          json['is_tshirt_picked'] == 1 || json['is_tshirt_picked'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'delivery_id': id,
      'name': name,
      'email': email,
      'country_code': countryCode,
      'phone_number': phoneNumber,
      'language': language,
      'status': status,
      'profile_image': profileImage,
      'city': city,
      'state': state,
      'total_deduction_balance': totalDeductionBalance,
      'avg_rating': avgRating,
      'total_ratings': totalRatings,
      'can_online': canOnline,
      'term_toggle': termToggle,
      'is_tshirt_picked': isTshirtPicked,
    };
  }
}

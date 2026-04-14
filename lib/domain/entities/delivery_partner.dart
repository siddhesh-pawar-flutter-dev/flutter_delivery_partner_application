class DeliveryPartner {
  const DeliveryPartner({
    required this.id,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
    required this.language,
    required this.status,
    required this.profileImage,
    required this.city,
    required this.state,
    required this.totalDeductionBalance,
    required this.avgRating,
    required this.totalRatings,
    required this.canOnline,
    required this.termToggle,
    required this.isTshirtPicked,
  });

  final int id;
  final String name;
  final String email;
  final String countryCode;
  final String phoneNumber;
  final String language;
  final String status;
  final String profileImage;
  final String city;
  final String state;
  final double totalDeductionBalance;
  final double avgRating;
  final int totalRatings;
  final bool canOnline;
  final bool termToggle;
  final bool isTshirtPicked;

  DeliveryPartner copyWith({
    int? id,
    String? name,
    String? email,
    String? countryCode,
    String? phoneNumber,
    String? language,
    String? status,
    String? profileImage,
    String? city,
    String? state,
    double? totalDeductionBalance,
    double? avgRating,
    int? totalRatings,
    bool? canOnline,
    bool? termToggle,
    bool? isTshirtPicked,
  }) {
    return DeliveryPartner(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      language: language ?? this.language,
      status: status ?? this.status,
      profileImage: profileImage ?? this.profileImage,
      city: city ?? this.city,
      state: state ?? this.state,
      totalDeductionBalance: totalDeductionBalance ?? this.totalDeductionBalance,
      avgRating: avgRating ?? this.avgRating,
      totalRatings: totalRatings ?? this.totalRatings,
      canOnline: canOnline ?? this.canOnline,
      termToggle: termToggle ?? this.termToggle,
      isTshirtPicked: isTshirtPicked ?? this.isTshirtPicked,
    );
  }
}

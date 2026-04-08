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
}

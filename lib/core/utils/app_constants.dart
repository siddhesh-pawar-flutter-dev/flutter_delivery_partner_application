class AppConstants {
  static const String baseUrl =
      'https://restaurant.techxsolutions.in/api_call/v1';

  static const String sendOtp = '/restaurants/send-otp-with-mobile';
  static const String verifyOtp = '/login/delivery-mobile';
  static const String profile = '/delivery-partner/details';
  static const String myOrders = '/delivery-partner/my-orders';
  static const String onlineStatus = '/delivery-partner/online-status';
  static const String gigHistory = '/gigs/rider/gig_hisotry_list';
  static const String gigByDate = '/gigs/rider/gig-by-date';
  static const String myPayouts = '/delivery-partner/my-payouts';

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_json';
  static const String languageKey = 'selected_language';

  static const List<LanguageOption> languages = [
    LanguageOption(value: 'English', nativeLabel: 'English', subtitle: ''),
    LanguageOption(value: 'Hindi', nativeLabel: 'हिंदी', subtitle: 'Hindi'),
    LanguageOption(value: 'Telugu', nativeLabel: 'తెలుగు', subtitle: 'Telugu'),
    LanguageOption(value: 'Kannada', nativeLabel: 'ಕನ್ನಡ', subtitle: 'Kannada'),
    LanguageOption(value: 'Tamil', nativeLabel: 'தமிழ்', subtitle: 'Tamil'),
    LanguageOption(value: 'Marathi', nativeLabel: 'मराठी', subtitle: 'Marathi'),
    LanguageOption(value: 'Bengali', nativeLabel: 'বাংলা', subtitle: 'Bengali'),
    LanguageOption(
      value: 'Malayalam',
      nativeLabel: 'മലയാളം',
      subtitle: 'Malayalam',
    ),
  ];
}

class LanguageOption {
  const LanguageOption({
    required this.value,
    required this.nativeLabel,
    required this.subtitle,
  });

  final String value;
  final String nativeLabel;
  final String subtitle;
}

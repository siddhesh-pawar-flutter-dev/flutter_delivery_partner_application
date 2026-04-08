class AppConstants {
  static const String baseUrl =
      'https://restaurant.techxsolutions.in/api_call/v1';

  static const String sendOtp = '/restaurants/send-otp-with-mobile';
  static const String verifyOtp = '/login/delivery-mobile';
  static const String profile = '/delivery-partner/details';
  static const String myOrders = '/delivery-partner/my-orders';

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_json';
  static const String languageKey = 'selected_language';

  static const List<String> languages = [
    'English',
    'Hindi',
    'Gujarati',
    'Marathi',
    'Tamil',
    'Telugu',
  ];
}

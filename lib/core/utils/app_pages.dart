import 'package:get/get.dart';

import '../../presentation/bindings/auth_binding.dart';
import '../../presentation/bindings/home_binding.dart';
import '../../presentation/bindings/language_binding.dart';
import '../../presentation/bindings/profile_binding.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/language_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/otp_page.dart';
import '../../presentation/pages/order_detail_page.dart';
import '../../presentation/pages/profile_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/tshirt_selection_page.dart';

class AppPages {
  static const String splash = '/';
  static const String language = '/language';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String tshirtSelection = '/tshirt-selection';
  static const String orderDetail = '/order-detail';

  static final routes = <GetPage>[
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(
      name: language,
      page: () => const LanguagePage(),
      binding: LanguageBinding(),
    ),
    GetPage(name: login, page: () => const LoginPage(), binding: AuthBinding()),
    GetPage(name: otp, page: () => const OtpPage(), binding: AuthBinding()),
    GetPage(name: home, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(
      name: profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(name: tshirtSelection, page: () => const TshirtSelectionPage()),
    GetPage(name: orderDetail, page: () => const OrderDetailPage()),
  ];
}

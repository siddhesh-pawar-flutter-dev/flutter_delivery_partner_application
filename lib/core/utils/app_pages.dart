import 'package:get/get.dart';

import '../../presentation/bindings/auth_binding.dart';
import '../../presentation/bindings/language_binding.dart';
import '../../presentation/bindings/main_shell_binding.dart';
import '../../presentation/pages/language_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/main_shell_page.dart';
import '../../presentation/pages/order_detail_page.dart';
import '../../presentation/pages/otp_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/tshirt_selection_page.dart';

class AppPages {
  static const String splash = '/';
  static const String language = '/language';
  static const String login = '/login';
  static const String otp = '/otp';

  /// The main shell that hosts Home / Orders / Profile tabs.
  static const String main = '/main';

  // Legacy aliases kept so any remaining Get.toNamed calls still compile.
  // They all redirect to the shell.
  static const String home = '/main';
  static const String orderHistory = '/main';
  static const String profile = '/main';

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

    // Single shell that owns the bottom nav bar.
    GetPage(
      name: main,
      page: () => const MainShellPage(),
      binding: MainShellBinding(),
    ),

    GetPage(name: tshirtSelection, page: () => const TshirtSelectionPage()),
    // Order detail is a full-screen page pushed on top of the shell.
    GetPage(name: orderDetail, page: () => const OrderDetailPage()),
  ];
}

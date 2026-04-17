import 'package:get/get.dart';

import '../../presentation/bindings/auth_binding.dart';
import '../../presentation/bindings/gig_by_date_binding.dart';
import '../../presentation/bindings/language_binding.dart';
import '../../presentation/bindings/main_shell_binding.dart';
import '../../presentation/pages/gig_by_date_page.dart';
import '../../presentation/pages/language_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/main_shell_page.dart';
import '../../presentation/pages/order_detail_page/order_detail_page.dart';
import '../../presentation/pages/otp_page.dart';
import '../../presentation/bindings/personal_details_binding.dart';
import '../../presentation/pages/edit_profile_page.dart';
import '../../presentation/pages/personal_details_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/tshirt_selection_page.dart';

class AppPages {
  static const String splash = '/';
  static const String language = '/language';
  static const String login = '/login';
  static const String otp = '/otp';

  static const String main = '/main';

  static const String home = '/main';
  static const String orderHistory = '/main';
  static const String profile = '/main';
  static const String personalDetails = '/personal-details';
  static const String editProfile = '/edit-profile';
  static const String gigByDate = '/gig-by-date';

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

    GetPage(
      name: main,
      page: () => const MainShellPage(),
      binding: MainShellBinding(),
    ),

    GetPage(name: tshirtSelection, page: () => const TshirtSelectionPage()),

    GetPage(name: orderDetail, page: () => const OrderDetailPage()),

    GetPage(
      name: gigByDate,
      page: () => const GigByDatePage(),
      binding: GigByDateBinding(),
    ),
    GetPage(
      name: personalDetails,
      page: () => const PersonalDetailsPage(),
      binding: PersonalDetailsBinding(),
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfilePage(),
      binding: PersonalDetailsBinding(),
    ),
  ];
}

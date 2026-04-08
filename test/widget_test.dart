
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_delivery_partner_application/app_initializer.dart';
// import 'package:flutter_delivery_partner_application/main.dart';

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets('app shows splash screen on launch', (WidgetTester tester) async {
//     SharedPreferences.setMockInitialValues({});
//     await initializeAppDependencies();

//     await tester.pumpWidget(const DeliveryPartnerApp());
//     await tester.pump();

//     expect(find.text('Easy Cater'), findsOneWidget);
//     expect(find.text('Delivery partner console'), findsOneWidget);
//   });
// }
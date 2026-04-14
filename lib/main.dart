import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_initializer.dart';
import 'core/utils/app_pages.dart';
import 'core/utils/app_theme.dart';
import 'presentation/controllers/app_binding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DeliveryPartnerApp());
}

class DeliveryPartnerApp extends StatefulWidget {
  const DeliveryPartnerApp({super.key});

  @override
  State<DeliveryPartnerApp> createState() => _DeliveryPartnerAppState();
}

class _DeliveryPartnerAppState extends State<DeliveryPartnerApp> {
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = initializeAppDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text(
                  'Unable to initialize app. Please restart.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return GetMaterialApp(
          title: 'Easy Cater Delivery',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          initialBinding: AppBinding(),
          initialRoute: AppPages.splash,
          getPages: AppPages.routes,
        );
      },
    );
  }
}

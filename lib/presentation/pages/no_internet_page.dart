import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/connectivity_controller.dart';
import '../widgets/primary_button.dart';

class NoInternetPage extends GetView<ConnectivityController> {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 72),
                const SizedBox(height: 18),
                Text('No internet connection', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(
                  'Please check your network and try again.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Retry',
                  onPressed: controller.retry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

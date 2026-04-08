import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/app_constants.dart';
import '../../core/utils/app_theme.dart';
import '../controllers/language_controller.dart';
import '../widgets/connectivity_gate.dart';
import '../widgets/primary_button.dart';

class LanguagePage extends GetView<LanguageController> {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LanguageController>();
    return ConnectivityGate(
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your language',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'This helps us personalize the onboarding flow for you.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: 
                  // Obx(
                  //   () => 
                    GridView.builder(
                      itemCount: AppConstants.languages.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 1.2,
                          ),
                      itemBuilder: (context, index) {
                        final language = AppConstants.languages[index];
                        final isSelected =
                            controller.selectedLanguage.value == language;
                        return GestureDetector(
                          onTap: () => controller.selectedLanguage.value = language,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppTheme.primary.withValues(alpha: 0.14)
                                      : AppTheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppTheme.primary
                                        : AppTheme.border,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.language_rounded,
                                  color:
                                      isSelected
                                          ? AppTheme.primary
                                          : Colors.white,
                                ),
                                const Spacer(),
                                Text(
                                  language,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  // ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => PrimaryButton(
                    label: 'Proceed',
                    onPressed:
                        controller.selectedLanguage.value.isEmpty
                            ? null
                            : controller.proceed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/personal_details_controller.dart';
import '../../widgets/primary_button.dart';

class EditProfilePage extends GetView<PersonalDetailsController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField(
                label: 'Full Name',
                controller: controller.nameController,
                validator: controller.validateName,
              ),
              const SizedBox(height: 24),
              _buildField(
                label: 'Email Address',
                controller: controller.emailController,
                validator: controller.validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              _buildField(
                label: 'Phone Number',
                controller: controller.phoneController,
                validator: controller.validatePhone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      label: 'Date of Birth',
                      controller: controller.dobController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildField(
                      label: 'Zip Code',
                      controller: controller.zipController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildField(
                label: 'Street Address',
                controller: controller.addressController,
                maxLines: 3,
              ),
              const SizedBox(height: 120), // Space for button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(
          () => PrimaryButton(
            label: 'Save Changes',
            isLoading: controller.isLoading.value,
            onPressed: controller.saveChanges,
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.inter(fontSize: 16),
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}

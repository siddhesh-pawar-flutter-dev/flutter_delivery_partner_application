import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/tshirt_selection_controller.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/tshirt_selection_page/components/product_card.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/tshirt_selection_page/components/size_selector.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class TshirtSelectionPage extends GetView<TshirtSelectionController> {
  const TshirtSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: const Text(
          'Delivery Uniform',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Header Section
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "Select Your Uniform  size and collect from the pickup location",
                    //       style: theme.textTheme.bodyLarge?.copyWith(
                    //         color: colorScheme.onSurface,
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //     // const SizedBox(height: 8),
                    //     // Text(
                    //     //   "Choose your size and collect from the pickup location",
                    //     //   style: theme.textTheme.bodyMedium?.copyWith(
                    //     //     color: colorScheme.onSurfaceVariant,
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),

                    // const SizedBox(height: 32),

                    // 🔹 T-shirt Preview Card
                    _buildPreviewCard(context, colorScheme),

                    const SizedBox(height: 32),

                    const SizeSelector(),
                  ],
                ),
              ),
            ),

            // 🔻 Pickup Location Card
            Padding(
              padding:
                  EdgeInsets.zero, // symmetric(horizontal: 20, vertical: 16),
              // symmetric(horizontal: 20, vertical: 16),
              child: const PickupLocationCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.08),
            colorScheme.primary.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Top Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  "Official Gear",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // T-shirt Icon Container
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
            child: Center(
              child: Icon(
                Icons.checkroom_rounded,
                size: 80,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            "Your Delivery Partner Uniform",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            "Complete your setup with your official uniform",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),

          // Features Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _featureBadge(
                context,
                Icons.local_shipping_rounded,
                "Free",
                colorScheme,
              ),
              _featureBadge(
                context,
                Icons.star_rounded,
                "Premium",
                colorScheme,
              ),
              _featureBadge(
                context,
                Icons.assignment_turned_in_rounded,
                "Required",
                colorScheme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureBadge(
    BuildContext context,
    IconData icon,
    String label,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: colorScheme.primary),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

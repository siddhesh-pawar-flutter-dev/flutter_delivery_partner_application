import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/home_controller.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/home_page/components/earning_stat.dart';
import 'package:flutter_delivery_partner_application/presentation/widgets/active_order_section.dart';
import 'package:get/get.dart';

class WeeklyEarningsCard extends GetView<HomeController> {
  const WeeklyEarningsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEEKLY EARNINGS',
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Obx(
                () => Text(
                  controller.getCurrency(controller.weeklyEarnings),
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '+12%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: EarningStat(label: 'TIPS INCLUDED', value: '₹342.00'),
              ),
              Container(
                width: 1,
                height: 32,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              Expanded(
                child: EarningStat(
                  label: 'NET BALANCE',
                  value: controller.getCurrency(
                    controller.weeklyEarnings - 342,
                  ),
                  isRight: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ScaleInteraction(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Center(
                child: Text(
                  'Withdraw',
                  style: TextStyle(
                    color: Color(0xFF2d8a39),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

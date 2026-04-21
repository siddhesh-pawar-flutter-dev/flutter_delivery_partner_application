import 'package:flutter/material.dart';
import 'package:flutter_delivery_partner_application/presentation/controllers/payout_history_controller.dart';
import 'package:flutter_delivery_partner_application/presentation/pages/payout_history_page/components/payout_filter_chip.dart';

class PayoutFilters extends StatelessWidget {
  const PayoutFilters({super.key, required this.controller});

  final PayoutHistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        PayoutFilterChip(
          icon: Icons.calendar_month_rounded,
          label: controller.selectedDateLabel,
          isSelected: controller.selectedDate.value != null,
          onTap: () {
            controller.selectDate(context);
          },
        ),
        PayoutFilterChip(
          icon: Icons.payments_rounded,
          label: 'All Payments',
          isSelected:
              controller.settlementFilter.value == PayoutSettlementFilter.all,
          onTap: () {
            controller.setSettlementFilter(PayoutSettlementFilter.all);
          },
        ),
        PayoutFilterChip(
          icon: Icons.check_circle_rounded,
          label: 'Settled',
          isSelected:
              controller.settlementFilter.value ==
              PayoutSettlementFilter.settled,
          onTap: () {
            controller.setSettlementFilter(PayoutSettlementFilter.settled);
          },
        ),
        PayoutFilterChip(
          icon: Icons.pending_actions_rounded,
          label: 'Not Settled',
          isSelected:
              controller.settlementFilter.value ==
              PayoutSettlementFilter.notSettled,
          onTap: () {
            controller.setSettlementFilter(PayoutSettlementFilter.notSettled);
          },
        ),
        if (controller.hasActiveFilters)
          PayoutFilterChip(
            icon: Icons.close_rounded,
            label: 'Clear',
            isSelected: false,
            onTap: controller.clearFilters,
          ),
      ],
    );
  }
}

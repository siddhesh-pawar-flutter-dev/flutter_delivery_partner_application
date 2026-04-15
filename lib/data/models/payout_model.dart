import '../../core/utils/formatters.dart';
import '../../domain/entities/payout.dart';

class PayoutItemModel extends PayoutItem {
  const PayoutItemModel({
    required super.id,
    required super.payoutId,
    required super.deliveryPartnerId,
    required super.orderId,
    required super.amount,
    required super.deductAmount,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory PayoutItemModel.fromJson(Map<String, dynamic> json) {
    return PayoutItemModel(
      id: Formatters.parseInt(json['id']),
      payoutId: json['payout_id'] != null ? Formatters.parseInt(json['payout_id']) : null,
      deliveryPartnerId: Formatters.parseInt(json['delivery_partner_id']),
      orderId: Formatters.parseInt(json['order_id']),
      amount: Formatters.parseAmount(json['amount']),
      deductAmount: Formatters.parseAmount(json['deduct_amount']),
      status: (json['status'] ?? '').toString(),
      createdAt: (json['createdAt'] ?? '').toString(),
      updatedAt: json['updatedAt']?.toString(),
      deletedAt: json['deletedAt']?.toString(),
    );
  }
}

class PayoutPageModel extends PayoutPageData {
  const PayoutPageModel({
    required super.payouts,
    required super.currentPage,
    required super.totalPages,
    required super.totalItems,
  });

  factory PayoutPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final payoutsJson = data['payouts'] as List<dynamic>? ?? [];
    final pagination = data['pagination'] as Map<String, dynamic>? ?? {};

    return PayoutPageModel(
      payouts: payoutsJson
          .map((item) =>
              PayoutItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: Formatters.parseInt(pagination['page']),
      totalPages: Formatters.parseInt(pagination['pages']),
      totalItems: Formatters.parseInt(pagination['total']),
    );
  }
}

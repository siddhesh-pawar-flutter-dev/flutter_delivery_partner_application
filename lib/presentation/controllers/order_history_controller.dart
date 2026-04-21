import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/error/failures.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/delivery_order.dart';
import '../../domain/usecases/get_order_history_usecase.dart';

class OrderHistoryController extends GetxController {
  OrderHistoryController({required GetOrderHistoryUseCase getOrdersUseCase})
    : _getOrdersUseCase = getOrdersUseCase;

  final GetOrderHistoryUseCase _getOrdersUseCase;
  final BaseCacheManager _cacheManager = DefaultCacheManager();

  final ScrollController scrollController = ScrollController();
  final RxList<DeliveryOrder> orders = <DeliveryOrder>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final int limit = 20;

  final RxString statusFilter = 'All'.obs;
  final Rxn<DateTime> dateFilter = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    loadAllOrders();
  }

  Future<void> refreshOrders() async {
    Hive.box('api_cache').clear();
    orders.clear();
    await loadAllOrders();
  }

  Future<void> loadAllOrders() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';
    orders.clear();

    try {
      final firstPage = await _getOrdersUseCase(page: 1, limit: limit);
      orders.addAll(firstPage.orders);
      unawaited(_warmOrderImages(firstPage.orders));

      final totalPages = firstPage.totalPage;

      for (int page = 2; page <= totalPages; page++) {
        final nextPage = await _getOrdersUseCase(page: page, limit: limit);
        orders.addAll(nextPage.orders);
        unawaited(_warmOrderImages(nextPage.orders));
      }
    } on Failure catch (error) {
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _warmOrderImages(List<DeliveryOrder> pageOrders) async {
    final urls = pageOrders
        .map((order) => order.imageUrl)
        .where((url) => url.isNotEmpty)
        .toSet()
        .take(12);

    for (final url in urls) {
      unawaited(_cacheManager.downloadFile(url));
    }
  }

  List<DeliveryOrder> get filteredOrders {
    var list = orders.toList();

    if (statusFilter.value == 'Last30Days') {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      list = list.where((order) {
        final parsed =
            Formatters.parseDateTime(order.createdAt) ??
            Formatters.parseDateTime(order.scheduledAt);
        if (parsed == null) return false;
        return parsed.isAfter(thirtyDaysAgo);
      }).toList();
    } else if (statusFilter.value == 'HighValue') {
      list = list.where((order) {
        return order.amount >= 500;
      }).toList();
    } else if (statusFilter.value != 'All') {
      list = list.where((order) {
        final status = order.status.trim().toLowerCase();
        if (statusFilter.value == 'Completed') {
          return status == 'completed' || status == 'delivered';
        } else if (statusFilter.value == 'Failed') {
          return status == 'cancelled' ||
              status == 'failed' ||
              status == 'not accepted' ||
              status == 'not_accepted' ||
              status == 'user_not_accepted';
        } else if (statusFilter.value == 'Cancelled') {
          return status == 'cancelled' ||
              status == 'failed' ||
              status == 'not accepted' ||
              status == 'not_accepted' ||
              status == 'user_not_accepted';
        } else if (statusFilter.value == 'Pending') {
          return status != 'completed' &&
              status != 'delivered' &&
              status != 'cancelled' &&
              status != 'failed' &&
              status != 'not accepted' &&
              status != 'not_accepted' &&
              status != 'user_not_accepted';
        }
        return true;
      }).toList();
    }

    if (dateFilter.value != null) {
      final targetDate = dateFilter.value!;
      list = list.where((order) {
        final parsed =
            Formatters.parseDateTime(order.createdAt) ??
            Formatters.parseDateTime(order.scheduledAt);
        if (parsed == null) return false;
        return parsed.year == targetDate.year &&
            parsed.month == targetDate.month &&
            parsed.day == targetDate.day;
      }).toList();
    }

    return list;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

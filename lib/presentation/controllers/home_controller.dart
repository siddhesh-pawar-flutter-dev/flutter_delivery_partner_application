import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/delivery_order.dart';
import '../../domain/entities/delivery_partner.dart';
import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/usecases/get_saved_user_usecase.dart';

class HomeController extends GetxController {
  HomeController({
    required GetOrderHistoryUseCase getOrdersUseCase,
    required GetSavedUserUseCase getSavedUserUseCase,
  }) : _getOrdersUseCase = getOrdersUseCase,
       _getSavedUserUseCase = getSavedUserUseCase;

  final GetOrderHistoryUseCase _getOrdersUseCase;
  final GetSavedUserUseCase _getSavedUserUseCase;

  final ScrollController scrollController = ScrollController();
  final RxList<DeliveryOrder> orders = <DeliveryOrder>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxString errorMessage = ''.obs;

  DeliveryPartner? user;
  int currentPage = 1;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    user = _getSavedUserUseCase();
    scrollController.addListener(_onScroll);
    loadOrders();
  }

  Future<void> refreshOrders() async {
    currentPage = 1;
    hasMoreData.value = true;
    orders.clear();
    await loadOrders();
  }

  Future<void> loadOrders() async {
    if (!hasMoreData.value || isLoading.value || isLoadingMore.value) return;

    final isFirstPage = currentPage == 1;
    if (isFirstPage) {
      isLoading.value = true;
      errorMessage.value = '';
    } else {
      isLoadingMore.value = true;
    }

    try {
      final page = await _getOrdersUseCase(page: currentPage, limit: limit);
      orders.addAll(page.orders);
      hasMoreData.value = currentPage < page.totalPage;
      if (hasMoreData.value) {
        currentPage++;
      }
    } on Failure catch (error) {
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final threshold = scrollController.position.maxScrollExtent - 200;
    if (scrollController.position.pixels >= threshold) {
      loadOrders();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

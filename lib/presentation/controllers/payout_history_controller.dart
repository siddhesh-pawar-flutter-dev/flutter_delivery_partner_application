import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../domain/entities/payout.dart';
import '../../domain/usecases/get_payout_history_usecase.dart';

class PayoutHistoryController extends GetxController {
  PayoutHistoryController({required this.getPayoutHistoryUseCase});

  final GetPayoutHistoryUseCase getPayoutHistoryUseCase;

  final payouts = <PayoutItem>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  late final ScrollController scrollController;

  int _currentPage = 1;
  int _totalPages = 1;
  static const int _limit = 10;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_onScroll);
    loadInitialData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    errorMessage.value = '';
    _currentPage = 1;

    try {
      final pageData = await getPayoutHistoryUseCase.execute(
        page: _currentPage,
        limit: _limit,
      );

      payouts.assignAll(pageData.payouts);
      _totalPages = pageData.totalPages;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadMore() async {
    if (isLoadingMore.value || _currentPage >= _totalPages) return;

    isLoadingMore.value = true;
    _currentPage++;

    try {
      final pageData = await getPayoutHistoryUseCase.execute(
        page: _currentPage,
        limit: _limit,
      );

      payouts.addAll(pageData.payouts);
      _totalPages = pageData.totalPages;
    } catch (e) {
      _currentPage--;
    } finally {
      isLoadingMore.value = false;
    }
  }
}

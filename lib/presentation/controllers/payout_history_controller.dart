import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities/payout.dart';
import '../../domain/usecases/get_payout_history_usecase.dart';

enum PayoutSettlementFilter { all, settled, notSettled }

class PayoutHistoryController extends GetxController {
  PayoutHistoryController({required this.getPayoutHistoryUseCase});

  final GetPayoutHistoryUseCase getPayoutHistoryUseCase;

  final payouts = <PayoutItem>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;
  final settlementFilter = PayoutSettlementFilter.all.obs;
  final selectedDate = Rxn<DateTime>();

  late final ScrollController scrollController;

  int _currentPage = 1;
  int _totalPages = 1;
  static const int _limit = 10;

  bool get hasActiveFilters =>
      settlementFilter.value != PayoutSettlementFilter.all ||
      selectedDate.value != null;

  String get selectedDateLabel {
    final date = selectedDate.value;
    if (date == null) return 'Select Date';
    return Formatters.formatDateTime(date, format: 'dd/MM/yyyy');
  }

  List<PayoutItem> get filteredPayouts {
    var list = payouts.toList();

    if (settlementFilter.value != PayoutSettlementFilter.all) {
      list = list.where((payout) {
        final isSettled = _isSettledPayout(payout);
        return settlementFilter.value == PayoutSettlementFilter.settled
            ? isSettled
            : !isSettled;
      }).toList();
    }

    final date = selectedDate.value;
    if (date != null) {
      list = list
          .where((payout) => _isSameDate(payout.createdAt, date))
          .toList();
    }

    return list;
  }

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

      if (hasActiveFilters) {
        await _loadRemainingPagesForFilters();
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadMore() async {
    if (isLoadingMore.value || _currentPage >= _totalPages) return;

    isLoadingMore.value = true;

    try {
      await _loadNextPage();
    } catch (_) {
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> setSettlementFilter(PayoutSettlementFilter filter) async {
    settlementFilter.value = filter;
    await _loadRemainingPagesForFilters();
  }

  Future<void> selectDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );

    if (pickedDate == null) return;

    selectedDate.value = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
    );
    await _loadRemainingPagesForFilters();
  }

  Future<void> clearDateFilter() async {
    selectedDate.value = null;
    await _loadRemainingPagesForFilters();
  }

  void clearFilters() {
    settlementFilter.value = PayoutSettlementFilter.all;
    selectedDate.value = null;
  }

  Future<void> _loadRemainingPagesForFilters() async {
    if (!hasActiveFilters ||
        isLoadingMore.value ||
        _currentPage >= _totalPages) {
      return;
    }

    isLoadingMore.value = true;

    try {
      while (_currentPage < _totalPages) {
        await _loadNextPage();
      }
    } catch (_) {
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> _loadNextPage() async {
    final nextPage = _currentPage + 1;
    final pageData = await getPayoutHistoryUseCase.execute(
      page: nextPage,
      limit: _limit,
    );

    payouts.addAll(pageData.payouts);
    _currentPage = pageData.currentPage > 0 ? pageData.currentPage : nextPage;
    _totalPages = pageData.totalPages;
  }

  bool _isSettledPayout(PayoutItem payout) {
    final status = payout.status.trim().toLowerCase();
    return status == 'settled' || status == 'completed';
  }

  bool _isSameDate(String value, DateTime date) {
    final parsed = Formatters.parseDateTime(value);
    if (parsed == null) return false;

    return parsed.year == date.year &&
        parsed.month == date.month &&
        parsed.day == date.day;
  }
}

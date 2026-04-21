import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/error/failures.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/delivery_order.dart';
import '../../domain/entities/delivery_partner.dart';
import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_saved_user_usecase.dart';

class HomeController extends GetxController {
  HomeController({
    required GetOrderHistoryUseCase getOrdersUseCase,
    required GetProfileUseCase getProfileUseCase,
    required GetSavedUserUseCase getSavedUserUseCase,
  }) : _getOrdersUseCase = getOrdersUseCase,
       _getProfileUseCase = getProfileUseCase,
       _getSavedUserUseCase = getSavedUserUseCase;

  final GetOrderHistoryUseCase _getOrdersUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final GetSavedUserUseCase _getSavedUserUseCase;
  final BaseCacheManager _cacheManager = DefaultCacheManager();

  final ScrollController scrollController = ScrollController();
  final RxList<DeliveryOrder> orders = <DeliveryOrder>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<DeliveryPartner> user = Rxn<DeliveryPartner>();

  int currentPage = 1;
  final int limit = 20;

  @override
  void onInit() {
    super.onInit();
    user.value = _getSavedUserUseCase();
    scrollController.addListener(_onScroll);
    unawaited(loadProfileSummary());
    loadOrders();
  }

  Future<void> refreshOrders() async {
    Hive.box('api_cache').clear();
    currentPage = 1;
    hasMoreData.value = true;
    orders.clear();
    await Future.wait([loadProfileSummary(), loadOrders()]);
  }

  String getCurrency(double value) {
    final hasDecimals = value.truncateToDouble() != value;
    return 'Rs ${value.toStringAsFixed(hasDecimals ? 2 : 0)}';
  }

  String getInitials(String? name) {
    final trimmed = name?.trim() ?? '';
    if (trimmed.isEmpty) return 'DP';
    final parts = trimmed.split(RegExp(r'\s+'));
    return (parts.first[0] + (parts.length > 1 ? parts[1][0] : ''))
        .toUpperCase();
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
      unawaited(_warmOrderImages(page.orders));
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

  Future<void> loadProfileSummary() async {
    try {
      final profile = await _getProfileUseCase();
      user.value = profile.deliveryPartner;
    } on Failure {
      //
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

  bool _isCompleted(DeliveryOrder order) {
    final status = order.status.trim().toLowerCase();
    return status == 'completed' || status == 'delivered';
  }

  bool _isActive(DeliveryOrder order) {
    final status = order.status.trim().toLowerCase();
    if (status == 'completed' || status == 'delivered') return false;
    if (status == 'cancelled' ||
        status == 'failed' ||
        status == 'not accepted' ||
        status == 'not_accepted' ||
        status == 'user_not_accepted') {
      return false;
    }
    return true;
  }

  List<DeliveryOrder> get todayOrders {
    final now = DateTime.now();
    return orders.where((order) {
      final parsed =
          Formatters.parseDateTime(order.createdAt) ??
          Formatters.parseDateTime(order.scheduledAt);
      if (parsed == null) return false;
      return parsed.year == now.year &&
          parsed.month == now.month &&
          parsed.day == now.day;
    }).toList();
  }

  double get todayEarnings {
    return todayOrders
        .where(_isCompleted)
        .fold(0, (sum, order) => sum + order.amount);
  }

  int get todayCompletedCount {
    return todayOrders.where(_isCompleted).length;
  }

  int get todayActiveCount {
    return todayOrders.where(_isActive).length;
  }

  int get todayTotalCount {
    return todayOrders.length;
  }

  double get weeklyEarnings {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return orders.where(_isCompleted).fold(0, (sum, order) {
      final parsed =
          Formatters.parseDateTime(order.createdAt) ??
          Formatters.parseDateTime(order.scheduledAt);
      if (parsed == null) return sum;
      if (parsed.isBefore(startOfWeek) || !parsed.isBefore(endOfWeek)) {
        return sum;
      }
      return sum + order.amount;
    });
  }

  bool get canReceiveOrders => (user.value?.canOnline ?? false);

  DeliveryOrder? get activeOrder {
    if (orders.isEmpty) return null;

    final nonCompleted = orders.where(_isActive).toList();

    if (nonCompleted.isNotEmpty) {
      nonCompleted.sort(_sortOrdersByMostRecent);
      return nonCompleted.first;
    }

    final sortedOrders = orders.toList()..sort(_sortOrdersByMostRecent);
    return sortedOrders.first;
  }

  String get greetingName {
    final name = user.value?.name.trim() ?? '';
    return name.isEmpty ? 'User' : name;
  }

  bool get shouldShowTshirtCard => !(user.value?.isTshirtPicked ?? false);

  Future<void> toggleOnlineStatus(bool isOnline) async {
    final previousUser = user.value;
    try {
      user.value = previousUser?.copyWith(canOnline: isOnline);

      await _getProfileUseCase.updateOnlineStatus(isOnline);

      Get.snackbar(
        'Success',
        isOnline ? 'You are now online' : 'You are now offline',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      user.value = previousUser;
      final message = error is Failure
          ? error.message
          : 'Failed to update status. Please try again.';
      Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
    }
  }

  int _sortOrdersByMostRecent(DeliveryOrder a, DeliveryOrder b) {
    final aDate =
        Formatters.parseDateTime(a.createdAt) ??
        Formatters.parseDateTime(a.scheduledAt) ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final bDate =
        Formatters.parseDateTime(b.createdAt) ??
        Formatters.parseDateTime(b.scheduledAt) ??
        DateTime.fromMillisecondsSinceEpoch(0);
    return bDate.compareTo(aDate);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.positions.length != 1) return;
    final position = scrollController.positions.first;
    final threshold = position.maxScrollExtent - 200;
    if (position.pixels >= threshold) {
      loadOrders();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

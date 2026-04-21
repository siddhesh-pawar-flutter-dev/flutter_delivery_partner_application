import 'package:flutter/widgets.dart';
import 'package:flutter_delivery_partner_application/core/utils/formatters.dart';
import 'package:get/get.dart';

import '../../domain/entities/gig_by_date.dart';
import '../../domain/usecases/get_gig_by_date_usecase.dart';

class GigByDateController extends GetxController {
  GigByDateController({required this.getGigByDateUseCase});

  final GetGigByDateUseCase getGigByDateUseCase;

  final gigs = <GigByDateItem>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  late final String date;
  late final ScrollController scrollController;

  int _currentPage = 1;
  int _totalPages = 1;
  static const int _limit = 10;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    date = args?['date'] as String? ?? '';
    
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
    if (date.isEmpty) {
      errorMessage.value = 'Invalid date provided';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    _currentPage = 1;

    try {
      final pageData = await getGigByDateUseCase.execute(
        selectedDate: date,
        page: _currentPage,
        limit: _limit,
      );

      gigs.assignAll(pageData.gigs);
      _totalPages = pageData.totalPages;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  String formatDate(String dateString) {
    try {
      final parsed = DateTime.parse(dateString);
      return Formatters.formatDateTime(parsed, format: 'dd/MM/yyyy');
    } catch (_) {
      return dateString;
    }
  }

  Future<void> _loadMore() async {
    if (isLoadingMore.value || _currentPage >= _totalPages || date.isEmpty) return;

    isLoadingMore.value = true;
    _currentPage++;

    try {
      final pageData = await getGigByDateUseCase.execute(
        selectedDate: date,
        page: _currentPage,
        limit: _limit,
      );

      gigs.addAll(pageData.gigs);
      _totalPages = pageData.totalPages;
    } catch (e) {
      _currentPage--;
    } finally {
      isLoadingMore.value = false;
    }
  }
}

import 'dart:async';

import 'package:get/get.dart';

import '../../core/network/network_info.dart';

class ConnectivityController extends GetxController {
  ConnectivityController({required NetworkInfo networkInfo})
    : _networkInfo = networkInfo;

  final NetworkInfo _networkInfo;

  final RxBool isOnline = true.obs;
  StreamSubscription<bool>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _loadStatus();
    _subscription = _networkInfo.onStatusChange.listen((status) {
      isOnline.value = status;
    });
  }

  Future<void> retry() => _loadStatus();

  Future<void> _loadStatus() async {
    isOnline.value = await _networkInfo.isConnected;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}

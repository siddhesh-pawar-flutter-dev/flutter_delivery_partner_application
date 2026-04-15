import 'package:get/get.dart';
import '../../core/utils/storage_service.dart';
import '../../data/datasources/online_status_remote_data_source.dart';
import '../../data/datasources/partner_remote_data_source.dart';
import '../../data/repositories/partner_repository_impl.dart';
import '../../domain/repositories/partner_repository.dart';
import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_saved_user_usecase.dart';
import '../controllers/home_controller.dart';
import '../controllers/main_shell_controller.dart';
import '../controllers/order_history_controller.dart';
import '../controllers/profile_controller.dart';

/// Binds all three tab controllers so they are available inside the shell.
class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    // Shared infrastructure
    Get.lazyPut<OnlineStatusRemoteDataSource>(
      () => OnlineStatusRemoteDataSourceImpl(Get.find()),
    );

    Get.lazyPut<PartnerRepository>(
      () => PartnerRepositoryImpl(
        Get.find<PartnerRemoteDataSource>(),
        Get.find<OnlineStatusRemoteDataSource>(),
      ),
    );

    // Tab navigation controller
    Get.lazyPut(() => MainShellController(), fenix: true);

    // Home tab
    Get.lazyPut(
      () => HomeController(
        getOrdersUseCase: Get.find<GetOrderHistoryUseCase>(),
        getProfileUseCase: Get.find<GetProfileUseCase>(),
        getSavedUserUseCase: Get.find<GetSavedUserUseCase>(),
      ),
      fenix: true,
    );

    // Orders tab
    Get.lazyPut(
      () => OrderHistoryController(
        getOrdersUseCase: Get.find<GetOrderHistoryUseCase>(),
      ),
      fenix: true,
    );

    // Profile tab
    Get.lazyPut(
      () => ProfileController(
        getProfileUseCase: Get.find<GetProfileUseCase>(),
        storageService: Get.find<StorageService>(),
      ),
      fenix: true,
    );
  }
}

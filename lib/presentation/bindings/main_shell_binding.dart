import 'package:get/get.dart';
import '../../core/utils/storage_service.dart';
import '../../data/datasources/gig_remote_data_source.dart';
import '../../data/datasources/online_status_remote_data_source.dart';
import '../../data/datasources/partner_remote_data_source.dart';
import '../../data/datasources/payout_remote_data_source.dart';
import '../../data/repositories/gig_repository_impl.dart';
import '../../data/repositories/partner_repository_impl.dart';
import '../../data/repositories/payout_repository_impl.dart';
import '../../domain/repositories/gig_repository.dart';
import '../../domain/repositories/partner_repository.dart';
import '../../domain/repositories/payout_repository.dart';
import '../../domain/usecases/get_gig_history_usecase.dart';
import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/usecases/get_payout_history_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_saved_user_usecase.dart';
import '../controllers/gig_history_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/main_shell_controller.dart';
import '../controllers/order_history_controller.dart';
import '../controllers/payout_history_controller.dart';
import '../controllers/profile_controller.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnlineStatusRemoteDataSource>(
      () => OnlineStatusRemoteDataSourceImpl(Get.find()),
    );

    Get.lazyPut<GigRemoteDataSource>(
      () => GigRemoteDataSourceImpl(Get.find()),
    );

    Get.lazyPut<GigRepository>(
      () => GigRepositoryImpl(Get.find<GigRemoteDataSource>()),
    );

    Get.lazyPut<GetGigHistoryUseCase>(
      () => GetGigHistoryUseCase(Get.find<GigRepository>()),
    );

    Get.lazyPut<PayoutRemoteDataSource>(
      () => PayoutRemoteDataSourceImpl(Get.find()),
    );

    Get.lazyPut<PayoutRepository>(
      () => PayoutRepositoryImpl(Get.find<PayoutRemoteDataSource>()),
    );

    Get.lazyPut<GetPayoutHistoryUseCase>(
      () => GetPayoutHistoryUseCase(Get.find<PayoutRepository>()),
    );

    Get.lazyPut<PartnerRepository>(
      () => PartnerRepositoryImpl(
        Get.find<PartnerRemoteDataSource>(),
        Get.find<OnlineStatusRemoteDataSource>(),
      ),
    );

    Get.lazyPut(() => MainShellController(), fenix: true);

    Get.lazyPut(
      () => HomeController(
        getOrdersUseCase: Get.find<GetOrderHistoryUseCase>(),
        getProfileUseCase: Get.find<GetProfileUseCase>(),
        getSavedUserUseCase: Get.find<GetSavedUserUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => OrderHistoryController(
        getOrdersUseCase: Get.find<GetOrderHistoryUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => ProfileController(
        getProfileUseCase: Get.find<GetProfileUseCase>(),
        storageService: Get.find<StorageService>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => GigHistoryController(
        getGigHistoryUseCase: Get.find<GetGigHistoryUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => PayoutHistoryController(
        getPayoutHistoryUseCase: Get.find<GetPayoutHistoryUseCase>(),
      ),
      fenix: true,
    );
  }
}


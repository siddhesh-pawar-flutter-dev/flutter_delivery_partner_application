import 'package:get/get.dart';

import '../../data/datasources/online_status_remote_data_source.dart';
import '../../data/datasources/partner_remote_data_source.dart';
import '../../data/repositories/partner_repository_impl.dart';
import '../../domain/repositories/partner_repository.dart';
import '../../domain/usecases/get_order_history_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_saved_user_usecase.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnlineStatusRemoteDataSource>(
      () => OnlineStatusRemoteDataSourceImpl(Get.find()),
    );

    Get.lazyPut<PartnerRepository>(
      () => PartnerRepositoryImpl(
        Get.find<PartnerRemoteDataSource>(),
        Get.find<OnlineStatusRemoteDataSource>(),
      ),
    );

    Get.lazyPut(
      () => HomeController(
        getOrdersUseCase: Get.find<GetOrderHistoryUseCase>(),
        getProfileUseCase: Get.find<GetProfileUseCase>(),
        getSavedUserUseCase: Get.find<GetSavedUserUseCase>(),
      ),
      fenix: true,
    );
  }
}

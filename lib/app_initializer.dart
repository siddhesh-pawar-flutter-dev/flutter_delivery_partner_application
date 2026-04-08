import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/utils/storage_service.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/order_remote_data_source.dart';
import 'data/datasources/partner_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'data/repositories/partner_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/repositories/partner_repository.dart';
import 'domain/usecases/get_order_history_usecase.dart';
import 'domain/usecases/get_profile_usecase.dart';
import 'domain/usecases/get_saved_language_usecase.dart';
import 'domain/usecases/get_saved_user_usecase.dart';
import 'domain/usecases/is_logged_in_usecase.dart';
import 'domain/usecases/save_language_usecase.dart';
import 'domain/usecases/send_otp_usecase.dart';
import 'domain/usecases/verify_otp_usecase.dart';

Future<void> initializeAppDependencies({bool reset = false}) async {
  if (reset) {
    Get.reset();
  }

  final sharedPreferences = await SharedPreferences.getInstance();
  final storageService = StorageService(sharedPreferences);
  final apiClient = ApiClient(storageService);

  Get.put<StorageService>(storageService, permanent: true);
  Get.lazyPut<NetworkInfo>(() => NetworkInfo(), fenix: true);
  Get.put<ApiClient>(apiClient, permanent: true);

  Get.put<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(apiClient),
    permanent: true,
  );
  Get.put<PartnerRemoteDataSource>(
    PartnerRemoteDataSourceImpl(apiClient),
    permanent: true,
  );
  Get.put<OrderRemoteDataSource>(
    OrderRemoteDataSourceImpl(apiClient),
    permanent: true,
  );

  Get.put<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: Get.find<AuthRemoteDataSource>(),
      storageService: storageService,
    ),
    permanent: true,
  );
  Get.put<PartnerRepository>(
    PartnerRepositoryImpl(Get.find<PartnerRemoteDataSource>()),
    permanent: true,
  );
  Get.put<OrderRepository>(
    OrderRepositoryImpl(Get.find<OrderRemoteDataSource>()),
    permanent: true,
  );

  Get.put(SendOtpUseCase(Get.find<AuthRepository>()), permanent: true);
  Get.put(VerifyOtpUseCase(Get.find<AuthRepository>()), permanent: true);
  Get.put(GetSavedLanguageUseCase(Get.find<AuthRepository>()), permanent: true);
  Get.put(SaveLanguageUseCase(Get.find<AuthRepository>()), permanent: true);
  Get.put(GetSavedUserUseCase(Get.find<AuthRepository>()), permanent: true);
  Get.put(IsLoggedInUseCase(Get.find<AuthRepository>()), permanent: true);
  Get.put(GetProfileUseCase(Get.find<PartnerRepository>()), permanent: true);
  Get.put(GetOrderHistoryUseCase(Get.find<OrderRepository>()), permanent: true);
}

import 'package:get/get.dart';

import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AuthController(
        sendOtpUseCase: Get.find<SendOtpUseCase>(),
        verifyOtpUseCase: Get.find<VerifyOtpUseCase>(),
      ),
      fenix: true,
    );
  }
}

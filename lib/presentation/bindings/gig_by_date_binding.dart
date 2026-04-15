import 'package:get/get.dart';

import '../../domain/repositories/gig_repository.dart';
import '../../domain/usecases/get_gig_by_date_usecase.dart';
import '../controllers/gig_by_date_controller.dart';

class GigByDateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetGigByDateUseCase>(
      () => GetGigByDateUseCase(Get.find<GigRepository>()),
    );

    Get.lazyPut<GigByDateController>(
      () => GigByDateController(
        getGigByDateUseCase: Get.find<GetGigByDateUseCase>(),
      ),
    );
  }
}

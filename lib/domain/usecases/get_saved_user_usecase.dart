import '../entities/delivery_partner.dart';
import '../repositories/auth_repository.dart';

class GetSavedUserUseCase {
  GetSavedUserUseCase(this._repository);

  final AuthRepository _repository;

  DeliveryPartner? call() => _repository.getSavedUser();
}

import '../repositories/auth_repository.dart';

class GetSavedLanguageUseCase {
  GetSavedLanguageUseCase(this._repository);

  final AuthRepository _repository;

  String call() => _repository.getSavedLanguage();
}

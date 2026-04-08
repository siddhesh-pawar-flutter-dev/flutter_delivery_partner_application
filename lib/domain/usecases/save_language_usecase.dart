import '../repositories/auth_repository.dart';

class SaveLanguageUseCase {
  SaveLanguageUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call(String language) => _repository.saveLanguage(language);
}

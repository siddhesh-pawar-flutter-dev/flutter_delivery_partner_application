import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/delivery_partner_model.dart';
import 'app_constants.dart';

class StorageService {
  StorageService(this._preferences);

  final SharedPreferences _preferences;

  String? get token => _preferences.getString(AppConstants.tokenKey);

  Future<void> saveToken(String token) async {
    await _preferences.setString(AppConstants.tokenKey, token);
  }

  String get selectedLanguage =>
      _preferences.getString(AppConstants.languageKey) ?? '';

  Future<void> saveLanguage(String value) async {
    await _preferences.setString(AppConstants.languageKey, value);
  }

  Future<void> saveUser(DeliveryPartnerModel user) async {
    await _preferences.setString(
      AppConstants.userKey,
      jsonEncode(user.toJson()),
    );
  }

  DeliveryPartnerModel? getUser() {
    final raw = _preferences.getString(AppConstants.userKey);
    if (raw == null || raw.isEmpty) return null;
    return DeliveryPartnerModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> clearSession() async {
    await _preferences.remove(AppConstants.tokenKey);
    await _preferences.remove(AppConstants.userKey);
  }
}

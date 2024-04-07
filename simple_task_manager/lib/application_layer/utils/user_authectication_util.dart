import 'package:dartz/dartz.dart';
import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/application_layer/services/secure_storage_service.dart';
import 'package:simple_task_manager/data_layer/models/res/auth/auth_response_model.dart';
import 'package:simple_task_manager/global/types.dart';

final class UserAuthenticationUtil {
  static const _userTokenKey = "userTokenKey";
  static const _userIdKey = "userIdKey";
  static Future saveUserInfo(AuthResponseModel userInfo) async {
    try {
      await locator<SecureStorageService>()
          .storage
          .write(key: _userTokenKey, value: userInfo.token);
      await locator<SecureStorageService>()
          .storage
          .write(key: _userIdKey, value: userInfo.id.toString());
    } on Exception {
      rethrow;
    }
  }

  ///Get registered user token
  ///
  static Future<AppResponseType<String>> getUserToken() async {
    final storage = locator<SecureStorageService>().storage;
    try {
      var token = await storage.read(key: _userTokenKey);
      if (token?.isEmpty ?? true) {
        return left("No token data");
      }
      return Right(token ?? "");
    } on Exception catch (e) {
      return left(e);
    }
  }

  static Future<AppResponseType<String>> getUserId() async {
    final storage = locator<SecureStorageService>().storage;
    try {
      var userId = await storage.read(key: _userIdKey);
      if (userId?.isEmpty ?? true) {
        return left("No id data");
      }
      return Right(userId ?? "");
    } on Exception catch (e) {
      return left(e);
    }
  }

  static Future<bool> isUserLoggedIn() async {
    final storage = locator<SecureStorageService>().storage;
    try {
      var token = await storage.read(key: _userTokenKey);
      return token?.isNotEmpty ?? false;
    } on Exception {
      return false;
    }
  }

  ///Logout user by removing its stored token
  static Future logoutUser() async {
    try {
      final storage = locator<SecureStorageService>().storage;
      await storage.deleteAll();
    } on Exception {
      rethrow;
    }
  }
}

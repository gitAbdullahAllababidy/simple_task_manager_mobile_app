import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  late final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
}

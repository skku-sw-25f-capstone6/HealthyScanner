import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const appSecureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
  iOptions: IOSOptions(
    accountName: 'healthy_scanner',
  ),
);

const legacySecureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
  iOptions: IOSOptions(
    accountName: 'healtyScanner',
  ),
);

Future<void> migrateAndCleanupSecureStorage() async {
  await legacySecureStorage.deleteAll();
}

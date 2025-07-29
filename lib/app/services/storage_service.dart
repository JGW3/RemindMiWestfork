import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _storage = GetStorage();
  
  // User data keys
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String userTypeKey = 'user_type';
  static const String isLoggedInKey = 'isLoggedIn';
  
  // Getters for common user data
  static String? get userId => _storage.read(userIdKey);
  static String? get userEmail => _storage.read(userEmailKey);
  static String? get userName => _storage.read(userNameKey);
  static String? get userType => _storage.read(userTypeKey);
  static bool get isLoggedIn => _storage.read(isLoggedInKey) ?? false;
  
  // Setters for common user data
  static void setUserId(String? value) => _storage.write(userIdKey, value);
  static void setUserEmail(String? value) => _storage.write(userEmailKey, value);
  static void setUserName(String? value) => _storage.write(userNameKey, value);
  static void setUserType(String? value) => _storage.write(userTypeKey, value);
  static void setLoggedIn(bool value) => _storage.write(isLoggedInKey, value);
  
  // Generic read/write methods
  static T? read<T>(String key) => _storage.read<T>(key);
  static void write(String key, dynamic value) => _storage.write(key, value);
  static void remove(String key) => _storage.remove(key);
  static void erase() => _storage.erase();
}
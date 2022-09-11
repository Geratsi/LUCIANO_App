
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static set(String key, String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  // static setInt(String name, int data) async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   sp.setInt(name, data);
  // }

  static Future<String?> get(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  // static Future<int?> getInt(String name) async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   return sp.getInt(name);
  // }

  static remove(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.remove(key);
  }

  static clear() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}

class EncryptedStorage {
  static set(String key, String value) async {
    const FlutterSecureStorage ss = FlutterSecureStorage();
    await ss.write(key: key, value: value);
  }

  // static setInt(String name, int data) async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   sp.setInt(name, data);
  // }

  static Future<String?> get(String key) async {
    const FlutterSecureStorage ss = FlutterSecureStorage();
    return await ss.read(key: key);
  }

  // static Future<int?> getInt(String name) async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   return sp.getInt(name);
  // }

  static remove(String key) async {
    const FlutterSecureStorage ss = FlutterSecureStorage();
    return await ss.delete(key: key);
  }

  static clear() async {
    const FlutterSecureStorage ss = FlutterSecureStorage();
    await ss.deleteAll();
  }
}

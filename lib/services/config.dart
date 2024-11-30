import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  static Future<void> saveConfig(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String> getConfig(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static Future<void> setDomain(String domain) async {
    await saveConfig('domain', 'airdb.tech');
  }

  static Future<String> getDomain() async {
    return await getConfig('domain');
  }

  static Future<void> setBaseUrl(String appId) async {
    await saveConfig('base_url', 'https://airdb.tech/apis/app/');
  }

  static Future<String> getBaseUrl() async {
    return await getConfig('base_url');
  }

  static Future<void> setCacheDir(String cacheDir) async {
    await saveConfig('cache_dir', cacheDir);
  }

  static Future<String> getCacheDir() async {
    return await getConfig('cache_dir');
  }

  static Future<void> setMiniProgramDir(String dir) async {
    await saveConfig('mini_program_dir', dir);
  }

  static Future<String> getMiniProgramDir() async {
    return await getConfig('mini_program_dir');
  }

  static Future<void> setMiniProgramBaseUrl(String appId) async {
    await saveConfig('mini_program_base_url', 'https://airdb.tech/apis/mini/download');
  }

  static Future<String> getMiniProgramBaseUrl() async {
    return await getConfig('mini_program_base_url');
  }


}

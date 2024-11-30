import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

/// Get app installation time
Future<DateTime?> getAppInstallTime() async {
  try {
    if (Platform.isAndroid) {
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;
      final appFile = File('/data/app/$packageName-1/base.apk');
      if (await appFile.exists()) {
        return (await appFile.stat()).modified;
      }
    } else if (Platform.isIOS) {
      // iOS doesn't provide direct access to installation time
      final appDir = await Directory(
        (await getApplicationDocumentsDirectory()).path
      ).parent;
      if (await appDir.exists()) {
        final stat = await appDir.stat();
        print('appDir stat: $stat');
        /*
        // 如果是模拟器，返回当前时间作为安装时间
        if (Platform.environment['SIMULATOR_DEVICE_NAME'] != null) {
          return DateTime.now();
        }
        */
        return stat.modified;
      }
    }
    return null;
  } catch (e) {
    return null;
  }
}

/// Get app runtime duration since launch
class AppRuntime {
  static final DateTime _startTime = DateTime.now();
  
  static Future<Map<String, dynamic>> getRuntime() async {
    try {
      final installTime = await getAppInstallTime();
      final appDir = await getApplicationDocumentsDirectory();
      
      return {
        "app_install_dir": appDir.path,
        "app_install_time": installTime?.millisecondsSinceEpoch,
        "time_up": getUptime()
      };
    } catch (e, stackTrace) {
      // Log the error but return a valid map
      print('Error getting runtime info: $e\n$stackTrace');
      return {
        "app_install_dir": "",
        "app_install_time": null,
        "time_up": 0,
        "error": e.toString()
      };
    }
  }

  static int getUptime() {
    try {
      return DateTime.now().difference(_startTime).inSeconds;
    } catch (e) {
      return 0;
    }
  }
}

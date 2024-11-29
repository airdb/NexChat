import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

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
      // You can use document directory creation time as an approximation
      final appDir = Directory('/private/var/mobile/Containers/Data/Application/');
      if (await appDir.exists()) {
        return (await appDir.stat()).modified;
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
  
  static Map<String, dynamic> getRuntime() {
    return {
      "time_up": DateTime.now().difference(_startTime).inSeconds
    };
  }
}

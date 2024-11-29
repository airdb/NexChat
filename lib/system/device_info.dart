import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class SystemInfo {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<Map<String, String>> getDeviceInfo(BuildContext context) async {
    final Map<String, String> deviceData = {};
    
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        deviceData['deviceModel'] = androidInfo.model;
        deviceData['androidVersion'] = androidInfo.version.release;
        deviceData['manufacturer'] = androidInfo.manufacturer;
        deviceData['deviceBrand'] = androidInfo.brand;
        deviceData['deviceId'] = androidInfo.id;
        deviceData['sdkVersion'] = androidInfo.version.sdkInt.toString();
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        deviceData['deviceName'] = iosInfo.name;
        deviceData['systemName'] = iosInfo.systemName;
        deviceData['systemVersion'] = iosInfo.systemVersion;
        deviceData['deviceModel'] = iosInfo.model;
        deviceData['deviceId'] = iosInfo.identifierForVendor ?? '';
      }
    } catch (e) {
      print('getDeviceInfo error: $e');
    }
    
    return deviceData;
  }

  static void printDeviceInfo(Map<String, String> info) {
    info.forEach((key, value) {
      print('$key: $value');
    });
  }
} 
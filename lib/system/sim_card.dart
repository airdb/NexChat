import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class SimCardInfo {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<int> getSimCardCount(BuildContext context) async {
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        // Check telephony feature first
        if (!androidInfo.systemFeatures.contains('android.hardware.telephony')) {
          return 0;
        }
        // Check for dual SIM capability
        if (androidInfo.systemFeatures.contains('android.hardware.telephony.multisim')) {
          return 2; // Device supports dual SIM
        }
        return 1; // Single SIM support
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        // iOS devices that support SIM typically have single SIM
        // Newer iPhone models may support dual SIM (physical + eSIM)
        if (['iPod touch'].contains(iosInfo.model)) {
          return 0;
        }
        // For simplicity returning 1, though newer iPhones may support dual SIM
        return 1;
      }
      return 0;
    } catch (e) {
      print('getSimCardCount error: $e');
      return 0;
    }
  }

  static Future<bool> hasSimCard(BuildContext context) async {
    return await getSimCardCount(context) > 0;
  }

  static Future<bool> hasDualSim(BuildContext context) async {
    return await getSimCardCount(context) == 2;
  }

  

  static Future<Map<String, dynamic>> getSimCardInfo(BuildContext context) async {
    return {
        "simCardCount": await getSimCardCount(context),
        "hasSimCard": await hasSimCard(context),
        "hasDualSim": await hasDualSim(context)
    };
  }
}
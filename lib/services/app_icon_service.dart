import 'package:flutter/services.dart';

class AppIconService {
  static const platform = MethodChannel('com.example.nexchat/app_icon');

  static Future<void> changeAppIcon(String iconName) async {
    try {
      await platform.invokeMethod('changeAppIcon', {'icon': iconName});
    } on PlatformException catch (e) {
      print("Failed to change app icon: ${e.message}");
    }
  }
} 
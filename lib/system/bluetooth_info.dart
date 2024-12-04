import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothInfo {
  static Future<Map<String, dynamic>> getBluetoothInfo() async {
    try {
      final bool isAvailable = await FlutterBluePlus.isAvailable;
      final bool isOn = await FlutterBluePlus.isOn;
      
      List<Map<String, dynamic>> connectedDevices = [];
      
      // 获取已连接设备信息
      if (isOn) {
        final devices = await FlutterBluePlus.connectedDevices;
        for (final device in devices) {
          connectedDevices.add({
            'name': device.name,
            'id': device.id.toString(),
            // 'type': device.type.toString(),
          });
        }
      }

      return {
        'is_available': isAvailable,
        'is_on': isOn,
        'connected_devices': connectedDevices,
      };
    } catch (e) {
      print('Error getting bluetooth info: $e');
      return {
        'is_available': false,
        'is_on': false,
        'error': e.toString(),
      };
    }
  }
} 
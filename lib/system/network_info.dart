import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class NetworkInfoService {
  final _networkInfo = NetworkInfo();
  static const platform = MethodChannel('wifi_signal_strength');

  Future<Map<String, String?>> getWifiInfo() async {
    // Get location permission (Android required)

    if (await Permission.location.request().isGranted) {
      return {
        'error': 'Location permission not granted',
      };
    }

    try {
      final wifiName = await _networkInfo.getWifiName(); // Get WiFi name (SSID)
        final wifiBSSID = await _networkInfo.getWifiBSSID(); // Get WiFi BSSID
        final wifiIP = await _networkInfo.getWifiIP(); // Get WiFi IP address
        final wifiGatewayIP = await _networkInfo.getWifiGatewayIP(); // Get gateway IP
        final wifiSubmask = await _networkInfo.getWifiSubmask(); // Get subnet mask
        final signalStrength = await getWifiSignalStrength(); // await the result

        return {
          'ssid': wifiName,
          'bssid': wifiBSSID,
          'ip': wifiIP,
          'gateway': wifiGatewayIP,
          'subnet': wifiSubmask,
          'strength': signalStrength?.toString(), // convert to String
        };
      } catch (e) {
        print('Failed to get WiFi info: $e');
        return {
          'error': e.toString(),
        };
    }
  }

  Future<bool> isConnectedToWifi() async {
    try {
      final wifiName = await _networkInfo.getWifiName();
      return wifiName != null;
    } catch (e) {
      print('Check WiFi connection failed: $e');
      return false;
    }
  }

  Future<int?> getWifiSignalStrength() async {
    try {
      final result = await platform.invokeMethod('getWifiSignalStrength');
      return result as int;
    } on PlatformException catch (e) {
      print('Failed to get signal strength: ${e.message}');
      return null;
    }
  }
} 
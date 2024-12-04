import 'dart:async';
import 'http.dart';
import 'package:flutter/material.dart';
import '../system/device_info.dart';
import '../system/network_info.dart';
import '../system/sim_card.dart';
import '../system/runtime.dart';
import '../system/bluetooth_info.dart';
class HeartbeatService {
  static final HeartbeatService _instance = HeartbeatService._internal();
  factory HeartbeatService() => _instance;
  HeartbeatService._internal();

  Timer? _heartbeatTimer;
  final HttpService _apiService = HttpService();
  
  // Heartbeat interval (default 300 seconds)
  static const Duration heartbeatInterval = Duration(seconds: 3);
  
  BuildContext? _context;
  
  // Start heartbeat
  void startHeartbeat(BuildContext context) {
    _context = context;
    stopHeartbeat(); // Ensure previous heartbeat is stopped
    
    _heartbeatTimer = Timer.periodic(heartbeatInterval, (timer) {
      _sendHeartbeat();
    });
    
    print('Heartbeat service started');
  }

  // Stop heartbeat
  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    print('Heartbeat service stopped');
  }

  // Send heartbeat request
  Future<void> _sendHeartbeat() async {
    final networkInfo = NetworkInfoService();
    final isConnected = await networkInfo.isConnectedToWifi();
    print("Is connected to WiFi: $isConnected");
    
    try {
      if (_context == null) {
        print('Context is null, cannot send heartbeat');
        return;
      }
      
      final deviceInfo = await SystemInfo.getDeviceInfo(_context!);
      print("Device Info: $deviceInfo");

      Map<String, dynamic>? wifiInfo;
      try {
        wifiInfo = await networkInfo.getWifiInfo();
        print("Wifi Info: $wifiInfo");
      } catch (e) {
        print("Failed to get wifi info: $e");
        wifiInfo = null;
      }

      final payload = {
        'timestamp': DateTime.now().toIso8601String(),
        'device_info': deviceInfo,
        'wifi_info': wifiInfo,
        "sim_card_info": await SimCardInfo.getSimCardInfo(_context!),
        "runtime": await AppRuntime.getRuntime(),
        'bluetooth_info': await BluetoothInfo.getBluetoothInfo(),
      }; 

      print('Sending heartbeat payload: $payload');

      final response = await _apiService.post('/v1/heartbeat', body: payload);
      
      print('Heartbeat sent successfully: $response');
    } catch (e) {
      print('Failed to send heartbeat: $e');
      // Can add retry logic here
      _handleHeartbeatError(e);
    }
  }

  // Handle heartbeat error
  void _handleHeartbeatError(dynamic error) {
    // Can add retry logic or other error handling here
    print('Heartbeat error handled: $error');
  }

  // Manually trigger heartbeat
  Future<void> sendManualHeartbeat() async {
    await _sendHeartbeat();
  }

  // Check heartbeat status
  bool isRunning() {
    return _heartbeatTimer != null && _heartbeatTimer!.isActive;
  }
} 
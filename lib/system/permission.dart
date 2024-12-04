import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PermissionUtil {
  // camera related
  static final permissionCamera = Permission.camera;
  
  // storage related
  static final permissionStorage = Permission.storage;
  static final permissionPhotos = Permission.photos;
  static final permissionVideos = Permission.videos;
  
  // location related
  static final permissionLocation = Permission.location;
  static final permissionLocationAlways = Permission.locationAlways;
  static final permissionLocationWhenInUse = Permission.locationWhenInUse;
  
  // microphone and audio related
  static final permissionMicrophone = Permission.microphone;
  static final permissionSpeech = Permission.speech;
  
  // notification and contacts related
  static final permissionNotification = Permission.notification;
  static final permissionContacts = Permission.contacts;
  
  // calendar and reminders related
  static final permissionCalendar = Permission.calendar;
  static final permissionReminders = Permission.reminders;
  
  // sensors and health related
  static final permissionSensors = Permission.sensors;
  static final permissionActivityRecognition = Permission.activityRecognition;

  // bluetooth related
  static final permissionBluetooth = Permission.bluetooth;
  static final permissionBluetoothScan = Permission.bluetoothScan;
  static final permissionBluetoothAdvertise = Permission.bluetoothAdvertise;
  static final permissionBluetoothConnect = Permission.bluetoothConnect;

  static Future<bool> hasPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  static Future<bool> requestPermission(
    BuildContext context,
    Permission permission,
    String title,
    String content,
  ) async {
    final status = await permission.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final requestStatus = await permission.request();
      if (requestStatus.isGranted) {
        return true;
      }
      
      if (requestStatus.isPermanentlyDenied && context.mounted) {
        final bool? shouldOpenSettings = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('去设置'),
              ),
            ],
          ),
        );

        if (shouldOpenSettings == true) {
          await openAppSettings();
        }
        return false;
      }
    }
    
    return false;
  }

  /// Request all bluetooth related permissions
  static Future<bool> requestBluetoothPermissions(BuildContext context) async {
    // First check and request location permission
    final hasLocation = await requestPermission(
      context,
      permissionLocationWhenInUse,
      '需要位置权限',
      '蓝牙扫描功能需要位置权限才能正常使用',
    );
    if (!hasLocation) return false;

    // Request bluetooth scan permission
    final hasScan = await requestPermission(
      context,
      permissionBluetoothScan,
      '需要蓝牙扫描权限',
      '请允许应用使用蓝牙扫描功能以连接设备',
    );
    if (!hasScan) return false;

    // Request bluetooth connect permission
    final hasConnect = await requestPermission(
      context,
      permissionBluetoothConnect,
      '需要蓝牙连接权限',
      '请允许应用连接蓝牙设备',
    );
    if (!hasConnect) return false;

    // Request bluetooth advertise permission
    final hasAdvertise = await requestPermission(
      context,
      permissionBluetoothAdvertise,
      '需要蓝牙广播权限',
      '请允许应用使用蓝牙广播功能',
    );
    if (!hasAdvertise) return false;

    return true;
  }

  static Future<void> checkBluetoothPermissionStatus() async {
    final scanStatus = await permissionBluetoothScan.status;
    final connectStatus = await permissionBluetoothConnect.status;
    final advertiseStatus = await permissionBluetoothAdvertise.status;
    final locationStatus = await permissionLocationWhenInUse.status;
    
    print('Bluetooth Scan: $scanStatus');
    print('Bluetooth Connect: $connectStatus');
    print('Bluetooth Advertise: $advertiseStatus');
    print('Location: $locationStatus');
  }

  static Future<void> requestLocationPermission(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    
    // First show explanation dialog
    final bool shouldRequest = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations?.locationPermissionTitle ?? 'Location Access'),
        content: Text(localizations?.locationPermissionMessage ?? 'We need location access to:\n- Find nearby services\n- Provide location-based features\n- Improve your experience'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localizations?.cancel ?? 'Not Now'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localizations?.ok ?? 'Continue'),
          ),
        ],
      ),
    ) ?? false;

    if (shouldRequest) {
      await PermissionUtil.requestPermission(
        context,
        PermissionUtil.permissionLocationWhenInUse,
        localizations?.locationPermissionTitle ?? 'Location Permission Required',
        localizations?.locationPermissionMessage ?? 'App needs location permission to provide better service',
      );
    }
  }
} 
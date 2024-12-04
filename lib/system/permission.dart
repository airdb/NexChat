import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

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
    
    if (status.isDenied || status.isRestricted) {
      final requestStatus = await permission.request();
      if (requestStatus.isGranted) {
        return true;
      }
    }
    
    if ((status.isPermanentlyDenied || status.isRestricted) && context.mounted) {
      final bool? shouldOpenSettings = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
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
        final newStatus = await permission.status;
        return newStatus.isGranted;
      }
    }


    
    
    return false;
  }

  /// Request all bluetooth related permissions
  static Future<bool> requestBluetoothPermissions(BuildContext context) async {
    // First check and request location permission (required for Android)
    await requestLocationPermission(context);
    
    if (Platform.isAndroid) {
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

      // Only request advertise if really needed
      // final hasAdvertise = await requestPermission(...);
      // if (!hasAdvertise) return false;
    }
    
    print('Platform: ${Platform.operatingSystem}, isIOS: ${Platform.isIOS}');
    if (Platform.isIOS) {
      // On iOS, check if bluetooth is enabled
      final status = await Permission.bluetooth.status;
      print('Bluetooth status: $status');
      if (status.isDenied) {
        // Show dialog to guide user to Settings since iOS bluetooth permission
        // can only be changed in Settings
        final requestStatus = await requestPermission(
          context,
          permissionBluetooth,
          '需要蓝牙权限',
          '请在设置中允许应用使用蓝牙功能',
        );
        if (!requestStatus) return false;
      }
    }

    print('Bluetooth permissions granted');

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
    // Must request location permission from Geolocator
    await Geolocator.requestPermission();

    final status = await Permission.locationWhenInUse.status;
    print('Location status: $status, requestStatus: ${status.isGranted}. ${status.isDenied}');

    if (status.isDenied) {
      final requestStatus = await Permission.locationWhenInUse.request();
      print('Location requestStatus: $requestStatus, ${requestStatus.isGranted}');
      if (requestStatus.isGranted) {
        return;
      }
    }

    if (status.isGranted) {
      return;
    }

    if (status.isPermanentlyDenied) {
      final bool? shouldOpenSettings = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Location Permission Required'),
          content: Text('We need location permission to enable this feature.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Settings'),
            ),
          ],
        ),
      );

      if (shouldOpenSettings == true) {
        await openAppSettings();
      }
    }
  }
} 
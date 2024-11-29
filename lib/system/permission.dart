import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
} 
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device_apps_plus_platform_interface.dart';

/// An implementation of [DeviceAppsPlusPlatform] that uses method channels.
class MethodChannelDeviceAppsPlus extends DeviceAppsPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('device_apps_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<bool> isAppInstalled(String packageName) async {
    return await methodChannel.invokeMethod<bool>('isAppInstalled', {
          'package': packageName,
        }) ??
        false;
  }

  @override
  Future<Map<String, bool>> checkMultiple(List<String> packageNames) async {
    final Map<dynamic, dynamic> result = await methodChannel.invokeMethod(
      'checkMultiple',
      {'packages': packageNames},
    );
    return Map<String, bool>.from(result);
  }

  @override
  Future<bool> openApp(String packageName) async {
    final result = await methodChannel.invokeMethod<bool>('openApp', {
      'package': packageName,
    });
    return result ?? false;
  }
}

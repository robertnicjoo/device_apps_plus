import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'device_apps_plus_method_channel.dart';

abstract class DeviceAppsPlusPlatform extends PlatformInterface {
  /// Constructs a DeviceAppsPlusPlatform.
  DeviceAppsPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceAppsPlusPlatform _instance = MethodChannelDeviceAppsPlus();

  /// The default instance of [DeviceAppsPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelDeviceAppsPlus].
  static DeviceAppsPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeviceAppsPlusPlatform] when
  /// they register themselves.
  static set instance(DeviceAppsPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> isAppInstalled(String packageName) {
    throw UnimplementedError('isAppInstalled() has not been implemented.');
  }

  Future<Map<String, bool>> checkMultiple(List<String> packageNames) {
    throw UnimplementedError('checkMultiple() has not been implemented.');
  }

  Future<bool> openApp(String packageName) {
    throw UnimplementedError('openApp() has not been implemented.');
  }
}

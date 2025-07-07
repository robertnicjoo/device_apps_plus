import 'device_apps_plus_platform_interface.dart';

class DeviceAppsPlus {
  Future<String?> getPlatformVersion() {
    return DeviceAppsPlusPlatform.instance.getPlatformVersion();
  }

  Future<bool> isAppInstalled(String packageName) {
    return DeviceAppsPlusPlatform.instance.isAppInstalled(packageName);
  }

  Future<Map<String, bool>> checkMultiple(List<String> packageNames) {
    return DeviceAppsPlusPlatform.instance.checkMultiple(packageNames);
  }
}

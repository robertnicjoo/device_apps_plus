import 'package:flutter_test/flutter_test.dart';
import 'package:device_apps_plus/device_apps_plus.dart';
import 'package:device_apps_plus/device_apps_plus_platform_interface.dart';
import 'package:device_apps_plus/device_apps_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDeviceAppsPlusPlatform
    with MockPlatformInterfaceMixin
    implements DeviceAppsPlusPlatform {
  @override
  Future<String?> getPlatformVersion() async => '42';

  @override
  Future<bool> isAppInstalled(String packageName) async {
    // Fake logic: Holy Bible Offline installed, others not
    return packageName == "irando.co.id.holy_bible";
  }

  @override
  Future<Map<String, bool>> checkMultiple(List<String> packageNames) async {
    return {
      for (final pkg in packageNames)
        pkg: pkg == "irando.co.id.holy_bible" || pkg == "com.facebook.katana",
    };
  }
}

void main() {
  final DeviceAppsPlusPlatform initialPlatform =
      DeviceAppsPlusPlatform.instance;

  test('$MethodChannelDeviceAppsPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDeviceAppsPlus>());
  });

  test('getPlatformVersion returns mock version', () async {
    final deviceAppsPlusPlugin = DeviceAppsPlus();
    final mock = MockDeviceAppsPlusPlatform();
    DeviceAppsPlusPlatform.instance = mock;

    expect(await deviceAppsPlusPlugin.getPlatformVersion(), '42');
  });

  test(
    'isAppInstalled returns true only for irando.co.id.holy_bible',
    () async {
      final plugin = DeviceAppsPlus();
      final mock = MockDeviceAppsPlusPlatform();
      DeviceAppsPlusPlatform.instance = mock;

      expect(await plugin.isAppInstalled('irando.co.id.holy_bible'), true);
      expect(await plugin.isAppInstalled('com.instagram.android'), false);
    },
  );

  test('checkMultiple returns correct app install map', () async {
    final plugin = DeviceAppsPlus();
    final mock = MockDeviceAppsPlusPlatform();
    DeviceAppsPlusPlatform.instance = mock;

    final result = await plugin.checkMultiple([
      'irando.co.id.holy_bible',
      'com.instagram.android',
      'com.facebook.katana',
    ]);

    expect(result['irando.co.id.holy_bible'], true);
    expect(result['com.facebook.katana'], true);
    expect(result['com.instagram.android'], false);
  });
}

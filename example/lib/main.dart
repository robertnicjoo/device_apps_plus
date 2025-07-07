import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:device_apps_plus/device_apps_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _deviceAppsPlusPlugin = DeviceAppsPlus();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _deviceAppsPlusPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    final singleApp = 'irando.co.id.holy_bible';
    final multipleApps = [
      'irando.co.id.holy_bible',
      'com.facebook.katana',
      'com.instagram.android',
      'com.google.android.youtube',
      'com.example.nonexistentapp',
    ];

    bool isHolyBibleInstalled = false;
    Map<String, bool> multiCheck = {};

    try {
      isHolyBibleInstalled = await _deviceAppsPlusPlugin.isAppInstalled(
        singleApp,
      );
      multiCheck = await _deviceAppsPlusPlugin.checkMultiple(multipleApps);
    } catch (e) {
      debugPrint("Error during app check: $e");
    }

    if (!mounted) return;

    setState(() {
      _platformVersion =
          '''
Platform: $platformVersion

✅ isAppInstalled('$singleApp') = $isHolyBibleInstalled

📦 checkMultiple:
${multiCheck.entries.map((e) => '${e.key}: ${e.value ? "✔️" : "❌"}').join('\n')}
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Device Apps Plus Demo')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(_platformVersion, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

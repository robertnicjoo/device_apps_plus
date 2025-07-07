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
  String _outputText = 'Loading...';
  final _deviceAppsPlusPlugin = DeviceAppsPlus();

  final String singleApp = 'irando.co.id.holy_bible';
  final List<String> multipleApps = [
    'irando.co.id.holy_bible',
    'com.facebook.katana',
    'com.instagram.android',
    'com.google.android.youtube',
    'com.example.nonexistentapp',
  ];

  Map<String, bool> multiCheck = {};
  bool isHolyBibleInstalled = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _deviceAppsPlusPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      isHolyBibleInstalled =
      await _deviceAppsPlusPlugin.isAppInstalled(singleApp);
      multiCheck = await _deviceAppsPlusPlugin.checkMultiple(multipleApps);
    } catch (e) {
      debugPrint("Error during app check: $e");
    }

    if (!mounted) return;

    setState(() {
      _outputText = '''
Platform: $platformVersion

✅ isAppInstalled('$singleApp') = $isHolyBibleInstalled

📦 checkMultiple:
${multiCheck.entries.map((e) => '${e.key}: ${e.value ? "✔️" : "❌"}').join('\n')}
''';
    });
  }

  Future<void> _tryOpenBibleApp() async {
    final success = await _deviceAppsPlusPlugin.openApp(singleApp);
    if (!success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Holy Bible app not installed or can't be opened.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Device Apps Plus Demo')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_outputText, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _tryOpenBibleApp,
                icon: const Icon(Icons.open_in_new),
                label: const Text("Open Holy Bible App"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

## 1.0.2

- Added `openApp(String packageName)` method to launch an installed Android app.
- Native Android implementation using `Intent` fallback.
- No breaking changes.

## 1.0.1

- Improved `pubspec.yaml` description for pub.dev compliance.
- Added `screenshot.png` to README display.
- Cleaned up internal plugin structure.

## 1.0.0

- Initial release.
- Supports:
    - `isAppInstalled(String packageName)`
    - `checkMultiple(List<String> packageNames)`
- Supports Android SDK 21–36.

# Setup Guide

## Windows (PowerShell)
1. Install Flutter via https://docs.flutter.dev/get-started/install/windows and ensure `flutter` in PATH.
2. Open PowerShell in repo root and run `flutter doctor -v`.
3. In `apps/mobile`, run `flutter pub get` and `flutter run` (select target device).

## WSL (optional)
1. Install WSL 2 with Ubuntu and follow Flutter Linux install.
2. Share Windows SDKs via VS Code Remote if targeting Android emulators.
3. Run the same Flutter commands from the project root inside WSL.

## macOS
1. Install Xcode via the App Store and agree to license.
2. Install Flutter and add it to PATH (see Flutter macOS instructions).
3. Run `flutter doctor -v`, then `flutter pub get` and `flutter run`.

## How to run
1. `flutter pub get`
2. `flutter run`
3. For release builds, use `flutter build apk` or `flutter build ios`.

## Troubleshooting
- `flutter doctor` reports Android SDK issues? Install from SDK Manager.
- CocoaPods missing? Run `sudo gem install cocoapods` and `pod repo update` before `flutter run` on iOS.
- Stuck on dependency resolution? Delete `pubspec.lock` and run `flutter pub get` again.

## Env (.env)
- Copy pps/mobile/assets/.env.example to pps/mobile/assets/.env and fill in values.
- pps/mobile/assets/.env is ignored by git.

## Bootstrap scripts
- Windows: powershell -ExecutionPolicy Bypass -File scripts/bootstrap.ps1
- Mac/WSL: ash scripts/bootstrap.sh


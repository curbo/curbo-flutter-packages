import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum BuildMode { DEBUG, PROFILE, RELEASE }

class DeviceInfo {
  BuildMode currentBuildMode() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.RELEASE;
    }
    var result = BuildMode.PROFILE;

    //Little trick, since assert only runs on DEBUG mode
    assert(() {
      result = BuildMode.DEBUG;
      return true;
    }());
    return result;
  }

  Future<String> appVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return 'v ${packageInfo.version} (${packageInfo.buildNumber})';
  }

  Future<int> buildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return int.parse(packageInfo.buildNumber);
  }

  Future<int> androidVersion() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt ?? 21;
  }
}

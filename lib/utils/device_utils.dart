// lib/utils/device_utils.dart
@JS()
library;

import 'package:js/js.dart';

@JS('navigator.userAgent')
external String get userAgent;

class DeviceUtils {
  static bool isMobile() {
    final ua = userAgent.toLowerCase();
    return ua.contains('iphone') ||
        ua.contains('ipad') ||
        ua.contains('android') ||
        ua.contains('mobile');
  }
}

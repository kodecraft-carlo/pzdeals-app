import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformCheck {
  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMobile() {
    return !kIsWeb;
  }

  static bool isAndroid() {
    return Platform.isAndroid == true;
  }

  static bool isIos() {
    return Platform.isIOS == true;
  }
}

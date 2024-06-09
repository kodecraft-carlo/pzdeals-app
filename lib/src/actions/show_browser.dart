import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    debugPrint("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad(didLoadSuccessfully) {
    debugPrint("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
    debugPrint("ChromeSafari browser closed");
  }
}

void openBrowser(String url) async {
  debugPrint('openBrowser called with url: $url');
  final browser = OpenChromeSafariBrowser();
  final Uri uri = Uri.parse(url);
  // if (await canLaunchUrl(uri)) {
  //   debugPrint('launching url: $uri');
  //   await launchUrl(uri, mode: LaunchMode.externalApplication);
  // } else {
  //   debugPrint('Could not launch $uri');
  await browser.open(
      url: WebUri(url),
      settings: ChromeSafariBrowserSettings(
          shareState: CustomTabsShareState.SHARE_STATE_OFF,
          barCollapsingEnabled: true));
  // }
}

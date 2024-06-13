import 'dart:io';

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

Future<void> openBrowser(String url) async {
  debugPrint('openBrowser called with url: $url');
  final browser = OpenChromeSafariBrowser();
  // await browser.open(
  //     url: WebUri(url),
  //     settings: ChromeSafariBrowserSettings(
  //         shareState: CustomTabsShareState.SHARE_STATE_OFF,
  //         barCollapsingEnabled: true));
// UNCOMMENT ON TUESDAY

  // if (url.contains('https://pzdls.co')) {
  //   await browser.open(
  //       url: WebUri(url),
  //       settings: ChromeSafariBrowserSettings(
  //           shareState: CustomTabsShareState.SHARE_STATE_OFF,
  //           barCollapsingEnabled: true));
  // } else {
  final longUrl = await getUrl(url);
  final Uri uri;
  if (longUrl == null || longUrl.isEmpty) {
    if (url.contains('https://www.walmart.com') ||
        url.contains('https://www.amazon.com')) {
      uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        debugPrint('can launch url 0: $uri');
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await browser.open(
            url: WebUri(url),
            settings: ChromeSafariBrowserSettings(
                shareState: CustomTabsShareState.SHARE_STATE_OFF,
                barCollapsingEnabled: true));
      }
    } else {
      debugPrint('can launch url 1: $url');
      await browser.open(
          url: WebUri(url),
          settings: ChromeSafariBrowserSettings(
              shareState: CustomTabsShareState.SHARE_STATE_OFF,
              barCollapsingEnabled: true));
    }
  } else if (longUrl.contains('https://www.walmart.com') ||
      longUrl.contains('https://www.amazon.com')) {
    uri = Uri.parse(longUrl);
    if (await canLaunchUrl(uri)) {
      debugPrint('can launch url 2: $uri');
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('chrome safari browser 1');
      await browser.open(
          url: WebUri(url),
          settings: ChromeSafariBrowserSettings(
              shareState: CustomTabsShareState.SHARE_STATE_OFF,
              barCollapsingEnabled: true));
    }
  } else {
    debugPrint('chrome safari browser 2');
    await browser.open(
        url: WebUri(url),
        settings: ChromeSafariBrowserSettings(
            shareState: CustomTabsShareState.SHARE_STATE_OFF,
            barCollapsingEnabled: true));
  }
  // }
}

Future<String> getUrl(String url) async {
  final client = HttpClient();
  var uri = Uri.parse(url);
  var request = await client.getUrl(uri);
  request.followRedirects = false;
  var response = await request.close();
  int redirectCount = 0;
  const int maxRedirects = 3;

  while (response.isRedirect && redirectCount < maxRedirects) {
    response.drain();
    final location = response.headers.value(HttpHeaders.locationHeader);

    if (location != null) {
      uri = uri.resolve(location);
      if (location.contains('https://www.amazon.com') ||
          location.contains('https://www.walmart.com')) {
        return location;
      }
      request = await client.getUrl(uri);
      request.followRedirects = false;
      response = await request.close();
      redirectCount++;
      debugPrint('redirectCount: $redirectCount');
    } else {
      break;
    }
  }
  return url;
}

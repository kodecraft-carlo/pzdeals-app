import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

List<String> urlsList = [
  'https://www.amazon.com',
  'https://www.walmart.com',
  'https://goto.walmart.com'
];
Future<void> launchDealUrl(String url) async {
  debugPrint('launchDealUrl called with url: $url');
  final Uri uri;

  if (isInUrlList(url)) {
    uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  } else {
    final longUrl = await getUrl(url);
    if (longUrl.isNotEmpty) {
      uri = Uri.parse(longUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    }
  }
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
      if (isInUrlList(location)) {
        debugPrint('getUrl called with location: $location');
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

bool isInUrlList(String url) {
  return urlsList.any((urlItem) => url.contains(urlItem));
}

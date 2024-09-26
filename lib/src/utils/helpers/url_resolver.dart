import 'dart:io';
import 'package:flutter/material.dart';

Future<String> resolveShortenedURL(String shortUrl,
    {int redirectCount = 0}) async {
  debugPrint('resolveShortenedURL called with shortUrl: $shortUrl');
  const int maxRedirects = 10; // Set a limit to prevent infinite loops
  final client = HttpClient();

  if (redirectCount >= maxRedirects) {
    debugPrint('Max redirects reached');
    return shortUrl; // Stop after reaching the max redirects limit
  }

  try {
    final uri = Uri.parse(shortUrl);

    // Send a HEAD request to get headers without downloading the body
    final request = await client.headUrl(uri);
    request.followRedirects = false;
    final response = await request.close();

    debugPrint('Response status code: ${response.statusCode}');

    // Check if there is a redirect
    if (response.statusCode >= 300 && response.statusCode < 400) {
      // Get the location header which contains the redirected URL
      final redirectedUrl = response.headers.value(HttpHeaders.locationHeader);

      // Check if redirectedUrl is valid
      if (redirectedUrl != null && redirectedUrl.isNotEmpty) {
        debugPrint('Redirecting to: $redirectedUrl');
        return await resolveShortenedURL(redirectedUrl,
            redirectCount: redirectCount + 1);
      }
    } else {
      // If not a redirect, log the response and check the URL
      final finalUrl =
          response.headers.value(HttpHeaders.locationHeader) ?? shortUrl;
      debugPrint('Final URL after processing: $finalUrl');

      // Check if the final URL matches the desired pattern
      if (finalUrl.contains('https://www.pzdeals.com/products/')) {
        debugPrint('Final product URL found: $finalUrl');
        return finalUrl; // Return the final URL if it matches
      }
    }

    return shortUrl; // Return the original URL if no redirect or match found
  } catch (e) {
    debugPrint('Error resolving short URL: $e');
    return shortUrl; // Fallback to original URL in case of error
  } finally {
    // Ensure the HttpClient is closed after use
    client.close();
  }
}

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:pzdeals/config.dart';
import 'package:pzdeals/src/constants/index.dart';

class FirebaseDynamicLinksApi {
  final _firebaseDynamicLinks = FirebaseDynamicLinks.instance;
  Future<Uri> generateDealDynamicLink(String productId, String productName,
      String productDescription, String imageUrl, String handle) async {
    final String fallbackUrl = '${AppConfig.pzDealsStoreUrl}/$handle';
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: AppConfig.firebaseDynamicLinkBaseUrl,
      link: Uri.parse(
          '${AppConfig.firebaseDynamicLinkBaseUrl}/deals?id=$productId'),
      androidParameters: AndroidParameters(
        packageName: 'com.kodecraft.pzdeals',
        minimumVersion: 1,
        fallbackUrl: Uri.parse(
            fallbackUrl), //if provided, will open this instead of launching the appstore
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.app.pzdeals',
        minimumVersion: '1',
        appStoreId: '6502050921', // Your App Store ID
        fallbackUrl: Uri.parse(
            fallbackUrl), //if provided, will open this instead of launching the appstore
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: productName,
        description: 'Check this $productDescription from ${Wordings.appName}!',
        imageUrl: Uri.parse(imageUrl),
      ),
      navigationInfoParameters: const NavigationInfoParameters(
          // forcedRedirectEnabled: true,
          ),
    );

    final dynamicLink = await _firebaseDynamicLinks.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );
    final Uri shortUrl = dynamicLink.shortUrl;
    return shortUrl;
  }
}

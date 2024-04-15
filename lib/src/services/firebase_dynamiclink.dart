import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinksApi {
  final _firebaseDynamicLinks = FirebaseDynamicLinks.instance;
  Future<Uri> generateDealDynamicLink(String productId, String productName,
      String productDescription, String imageUrl) async {
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: 'https://pzdealsapp.page.link',
      link: Uri.parse('https://pzdealsapp.page.link/deals?id=$productId'),
      androidParameters: AndroidParameters(
        packageName: 'com.kodecraft.pzdeals',
        minimumVersion: 34,
        fallbackUrl: Uri.parse(
            'https://play.google.com/store/apps/details?id=com.facebook.katana'), // placeholder value only
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.kodecraft.pzdeals',
        minimumVersion: '0',
        appStoreId: 'id284882215', // Your App Store ID
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: productName,
        description:
            'Check out this amazing deal from PZ Deals! $productDescription',
        imageUrl: Uri.parse(imageUrl),
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

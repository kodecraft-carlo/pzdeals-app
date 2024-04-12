import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinksApi {
  final _firebaseDynamicLinks = FirebaseDynamicLinks.instance;
  Future<Uri> generateDealDynamicLink(String productId, String productName,
      String productDescription, String imageUrl) async {
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: 'https://pzdealsapp.page.link',
      link: Uri.parse('https://pzdealsapp.page.link/deals?id=$productId'),
      androidParameters: const AndroidParameters(
        packageName: 'com.kodecraft.pzdeals',
        minimumVersion: 34,
      ),
      // iosParameters: const IOSParameters(
      //   bundleId: 'com.yourapp.bundle',
      //   minimumVersion: '0',
      //   appStoreId: '123456789', // Your App Store ID
      // ),
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

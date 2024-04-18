import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/utils/helpers/convert_to_slug.dart';

class FirebaseDynamicLinksApi {
  final _firebaseDynamicLinks = FirebaseDynamicLinks.instance;
  Future<Uri> generateDealDynamicLink(String productId, String productName,
      String productDescription, String imageUrl) async {
    final String fallbackUrl =
        'https://www.pzdeals.com/products/${convertToSlug(productName)}';
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: 'https://pzdealsapp.page.link',
      link: Uri.parse('https://pzdealsapp.page.link/deals?id=$productId'),
      androidParameters: AndroidParameters(
        packageName: 'com.kodecraft.pzdeals',
        minimumVersion: 34,
        fallbackUrl: Uri.parse(fallbackUrl), // placeholder value only
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.kodecraft.pzdeals',
        minimumVersion: '0',
        appStoreId: 'id284882215', // Your App Store ID
        fallbackUrl: Uri.parse(fallbackUrl),
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: productName,
        description: 'Check this $productDescription from ${Wordings.appName}!',
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

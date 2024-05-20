import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/main.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/common_widgets/loading_dialog.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/screen_login_required.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/services/email_service.dart';
import 'package:pzdeals/src/services/firebase_dynamiclink.dart';
import 'package:pzdeals/src/services/products_service.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'package:pzdeals/src/state/bookmarks_provider.dart';
import 'package:pzdeals/src/state/productlikes_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ProductDealActions extends ConsumerStatefulWidget {
  const ProductDealActions({super.key, required this.productData});

  final ProductDealcardData productData;
  ProductDealActionsState createState() => ProductDealActionsState();
}

class ProductDealActionsState extends ConsumerState<ProductDealActions> {
  EmailService emailSvc = EmailService();
  ProductService productSvc = ProductService();
  FirebaseDynamicLinksApi dynamicLinkApi = FirebaseDynamicLinksApi();
  bool reportingSoldOut = false;
  void gotoLoginScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const LoginRequiredScreen(
        message: "Login to unlock amazing ${Wordings.appName} features!",
      );
    }));
  }

  Future<bool> updateProductStatus(int productId, String status,
      String productName, String productLink) async {
    //commented email sending: 04/15/2024
    // if (await productSvc.updateProductSoldoutStatus(productId, status) &&
    //     await emailSvc.sendEmailSoldOut(productName, productLink)) {
    //   return true;
    // }
    final deviceId = await getDeviceId();
    if (await productSvc.updateProductSoldoutStatus(productId, status) &&
        await productSvc.addToReportedProducts(productId, status, deviceId)) {
      return true;
    }
    return false;
  }

  Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    late String deviceId;

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = 'ios_${iosDeviceInfo.identifierForVendor!}';
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = 'android_${androidDeviceInfo.id}';
    } else {
      deviceId = 'null';
    }
    return deviceId;
  }

  Future<void> _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    String productDescription =
        '\'${widget.productData.productName}\' for only \$${widget.productData.price}';
    final dynamicLink = await dynamicLinkApi.generateDealDynamicLink(
        widget.productData.productId.toString(),
        widget.productData.productName,
        productDescription,
        widget.productData.imageAsset,
        widget.productData.handle ?? '');
    final result = await Share.shareWithResult(
      'Check this \'${widget.productData.productName}\' for only \$${widget.productData.price} from ${Wordings.appName}! $dynamicLink',
      subject: 'Product Deal from ${Wordings.appName}',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
    if (result.status == ShareResultStatus.success) {
      // showSnackbarWithMessage(context, 'Product deal shared!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkState = ref.watch(bookmarkedproductsProvider);
    final productLikeState = ref.watch(likedproductsProvider);
    final authUserDataState = ref.watch(authUserDataProvider);

    return
        // widget.productData.isProductExpired != null &&
        //         widget.productData.isProductExpired == false
        //     ?
        Container(
      padding: const EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              dealActionIconButton(
                  productLikeState.isLiked(widget.productData.productId)
                      ? const Icon(
                          Icons.thumb_up_alt_rounded,
                          color: PZColors.pzOrange,
                        )
                      : const Icon(Icons.thumb_up_outlined),
                  'Like', () {
                productLikeState.addToCachedProducts(
                    widget.productData.productId, 'like');
                if (productLikeState.isLiked(widget.productData.productId)) {
                  // showSnackbarWithMessage(
                  //     context, 'You like this deal!');
                }
              }),
              dealActionIconButton(
                  productLikeState.isDisliked(widget.productData.productId)
                      ? const Icon(
                          Icons.thumb_down_alt_rounded,
                          color: PZColors.pzOrange,
                        )
                      : const Icon(Icons.thumb_down_outlined),
                  'Dislike', () {
                if (authUserDataState.isAuthenticated == false) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginRequiredScreen(
                      message: "Login to ${Wordings.appName}!",
                    );
                  }));
                  return;
                } else {
                  productLikeState.addToCachedProducts(
                      widget.productData.productId, 'disliked');
                  if (productLikeState
                      .isDisliked(widget.productData.productId)) {
                    // showSnackbarWithMessage(
                    //     context, 'You dislike this deal!');
                  }
                }
              }),
              dealActionIconButton(
                  reportingSoldOut
                      ? const Icon(
                          Icons.sell_rounded,
                          color: PZColors.pzOrange,
                        )
                      : const Icon(Icons.sell_outlined),
                  'Sold-out', () async {
                if (authUserDataState.isAuthenticated == false) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginRequiredScreen(
                      message: "Login to ${Wordings.appName}!",
                    );
                  }));
                  return;
                }
                setState(() {
                  reportingSoldOut = true;
                });
                // if (mounted) LoadingDialog.show(context);
                updateProductStatus(
                        widget.productData.productId,
                        'soldout_pending',
                        widget.productData.productName,
                        widget.productData.barcodeLink ?? '')
                    .then((value) {
                  if (value == true) {
                    showSnackbarWithMessage(
                        context, 'Thanks for letting us know!');
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        reportingSoldOut = false;
                      });
                    });
                  }
                  // if (mounted) LoadingDialog.hide(context);
                });
              }),
              dealActionIconButton(
                  authUserDataState.isAuthenticated == true &&
                          bookmarkState
                              .isBookmarked(widget.productData.productId)
                      ? const Icon(
                          Icons.bookmark_added_rounded,
                          color: PZColors.pzOrange,
                          size: Sizes.screenCloseIconSize,
                        )
                      : const Icon(Icons.bookmark_border_outlined),
                  'Bookmark', () {
                if (authUserDataState.isAuthenticated == false) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginRequiredScreen(
                      message: "Login to ${Wordings.appName}!",
                    );
                  }));
                  // showSnackbarWithAction(
                  //     context,
                  //     'Please login to bookmark this deal',
                  //     gotoLoginScreen,
                  //     'Login');
                  return;
                } else {
                  if (bookmarkState
                      .isBookmarked(widget.productData.productId)) {
                    bookmarkState
                        .removeBookmarkLocally(widget.productData.productId);
                    // showSnackbarWithMessage(
                    //     context, 'Removed from bookmarks');
                  } else {
                    bookmarkState
                        .addBookmarkLocally(widget.productData.productId);
                    // showSnackbarWithMessage(
                    //     context, 'Added to bookmarks');
                  }
                }
              }),
              dealActionIconButton(const Icon(Icons.ios_share_rounded), 'Share',
                  () => _onShare(context)),
            ],
          ),
        ],
      ),
    );
    // : const SizedBox.shrink();
  }

  Widget dealActionIconButton(
      Widget dealIcon, String label, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                overlayColor: MaterialStateProperty.all(Colors.transparent)),
            icon: dealIcon,
            iconSize: Sizes.screenCloseIconSize,
            onPressed: onPressed as void Function()?,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: Sizes.bodySmallestSize),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

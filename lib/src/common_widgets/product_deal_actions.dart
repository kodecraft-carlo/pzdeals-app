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
import 'package:pzdeals/src/state/productlikes_provider.dart';
import 'package:share_plus/share_plus.dart';

class ProductDealActions extends ConsumerStatefulWidget {
  const ProductDealActions({super.key, required this.productData});

  final ProductDealcardData productData;
  ProductDealActionsState createState() => ProductDealActionsState();
}

class ProductDealActionsState extends ConsumerState<ProductDealActions> {
  EmailService emailSvc = EmailService();
  ProductService productSvc = ProductService();
  FirebaseDynamicLinksApi dynamicLinkApi = FirebaseDynamicLinksApi();
  void gotoLoginScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const LoginRequiredScreen(
        message: "Login to unlock amazing PZ Deals features!",
      );
    }));
  }

  Future<bool> updateProductStatus(int productId, String status,
      String productName, String productLink) async {
    if (await productSvc.updateProductSoldoutStatus(productId, status) &&
        await emailSvc.sendEmailSoldOut(productName, productLink)) {
      return true;
    }
    return false;
  }

  Future<void> _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    String productDescription =
        '\'${widget.productData.productName}\' for only USD${widget.productData.price}';
    final dynamicLink = await dynamicLinkApi.generateDealDynamicLink(
        widget.productData.productId.toString(),
        widget.productData.productName,
        productDescription,
        widget.productData.imageAsset);
    final result = await Share.shareWithResult(
      'Check out this amazing deal from PZ Deals! \'${widget.productData.productName}\' for only USD${widget.productData.price} $dynamicLink',
      subject: 'Product Deal from PZ Deals',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
    if (result.status == ShareResultStatus.success) {
      showSnackbarWithMessage(context, 'Product deal shared!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkState = ref.watch(bookmarkedproductsProvider);
    final productLikeState = ref.watch(likedproductsProvider);
    final authUserDataState = ref.watch(authUserDataProvider);

    Widget shareAction = Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.ios_share_rounded),
          iconSize: Sizes.screenCloseIconSize,
          onPressed: () => _onShare(context),
        );
      },
    );
    return widget.productData.isProductExpired != null &&
            widget.productData.isProductExpired == false
        ? Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon:
                          productLikeState.isLiked(widget.productData.productId)
                              ? const Icon(
                                  Icons.thumb_up_alt_rounded,
                                  color: PZColors.pzOrange,
                                )
                              : const Icon(Icons.thumb_up_outlined),
                      iconSize: Sizes.screenCloseIconSize,
                      onPressed: () {
                        productLikeState.addToCachedProducts(
                            widget.productData.productId, 'like');
                        if (productLikeState
                            .isLiked(widget.productData.productId)) {
                          showSnackbarWithMessage(
                              context, 'You like this deal!');
                        }
                      },
                    ),
                    IconButton(
                      icon: productLikeState
                              .isDisliked(widget.productData.productId)
                          ? const Icon(
                              Icons.thumb_down_alt_rounded,
                              color: PZColors.pzOrange,
                            )
                          : const Icon(Icons.thumb_down_outlined),
                      iconSize: Sizes.screenCloseIconSize,
                      onPressed: () {
                        productLikeState.addToCachedProducts(
                            widget.productData.productId, 'disliked');
                        if (productLikeState
                            .isDisliked(widget.productData.productId)) {
                          showSnackbarWithMessage(
                              context, 'You dislike this deal!');
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.sell_outlined),
                      iconSize: Sizes.screenCloseIconSize,
                      onPressed: () async {
                        if (mounted) LoadingDialog.show(context);
                        updateProductStatus(
                                widget.productData.productId,
                                'soldout_pending',
                                widget.productData.productName,
                                widget.productData.barcodeLink ?? '')
                            .then((value) {
                          if (value == true) {
                            showSnackbarWithMessage(
                                context, 'Thanks for letting us know!');
                          }
                          if (mounted) LoadingDialog.hide(context);
                        });
                      },
                    ),
                    IconButton(
                      icon: bookmarkState
                              .isBookmarked(widget.productData.productId)
                          ? const Icon(
                              Icons.bookmark_added_rounded,
                              color: PZColors.pzOrange,
                              size: Sizes.screenCloseIconSize,
                            )
                          : const Icon(Icons.bookmark_border_outlined),
                      iconSize: Sizes.screenCloseIconSize,
                      onPressed: () {
                        if (authUserDataState.isAuthenticated == false) {
                          showSnackbarWithAction(
                              context,
                              'Please login to bookmark this deal',
                              gotoLoginScreen,
                              'Login');
                          return;
                        } else {
                          if (bookmarkState
                              .isBookmarked(widget.productData.productId)) {
                            bookmarkState.removeBookmarkLocally(
                                widget.productData.productId);
                            showSnackbarWithMessage(
                                context, 'Removed from bookmarks');
                          } else {
                            bookmarkState.addBookmarkLocally(
                                widget.productData.productId);
                            showSnackbarWithMessage(
                                context, 'Added to bookmarks');
                          }
                        }
                      },
                    ),
                    shareAction
                  ],
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

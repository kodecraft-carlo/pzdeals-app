import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/stores/presentation/widgets/index.dart';
import 'package:pzdeals/src/models/index.dart';
import 'package:pzdeals/src/utils/storage/network_image_cache_manager.dart';

class StoreCardWidget extends StatefulWidget {
  final StoreData storeData;
  const StoreCardWidget({super.key, required this.storeData});
  @override
  StoreCardWidgetState createState() => StoreCardWidgetState();
}

class StoreCardWidgetState extends State<StoreCardWidget> {
  @override
  Widget build(BuildContext context) {
    // debugPrint('store card build ${widget.storeData.id}');
    return GestureDetector(
      onTap: () {
        if (widget.storeData.id != 0) {
          showDialog(
              context: context,
              useRootNavigator: false,
              builder: (context) => ScaffoldMessenger(
                    child: Builder(
                      builder: (context) => Scaffold(
                        backgroundColor: Colors.transparent,
                        body: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          behavior: HitTestBehavior.opaque,
                          child: GestureDetector(
                            onTap: () {},
                            child: StoreDialog(
                              storeName: widget.storeData.storeName,
                              storeImage: StoreIcon(
                                storeData: widget.storeData,
                              ),
                              htmlData: widget.storeData.storeBody ?? '',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const StoreInputDialog();
            },
          );
        }
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 9,
                  ),
                ],
              ),
              child: StoreIcon(
                storeData: widget.storeData,
              ),
            ),
          ),
          const SizedBox(height: Sizes.spaceBetweenContentSmall),
          Text(
            widget.storeData.storeName,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: PZColors.pzBlack,
                fontSize: Sizes.fontSizeXSmall,
                fontWeight: FontWeight.w500),
            textScaler: MediaQuery.textScalerOf(context),
          )
        ],
      ),
    );
  }
}

class StoreIcon extends StatefulWidget {
  const StoreIcon({super.key, required this.storeData});
  final StoreData storeData;
  @override
  StoreIconState createState() => StoreIconState();
}

class StoreIconState extends State<StoreIcon> {
  late ImageProvider imageProvider;
  double width = 80;
  double height = 80;

  @override
  void initState() {
    super.initState();
    if (widget.storeData.assetSourceType == 'asset') {
      imageProvider = AssetImage(widget.storeData.storeAssetImage);
    } else if (widget.storeData.assetSourceType == 'network') {
      imageProvider = NetworkImage(widget.storeData.storeAssetImage);
    } else {
      imageProvider = const AssetImage('assets/images/pzdeals_store.png');
    }
  }

  Widget defaultImage() {
    return Image.asset(
      'assets/images/pzdeals_store.png',
      width: width,
      height: height,
      fit: BoxFit.fitWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image(
      image: imageProvider,
      width: width,
      height: height,
      fit: BoxFit.fitWidth,
    );

    if (widget.storeData.assetSourceType == 'network') {
      try {
        if (_isSvgImage(widget.storeData.storeAssetImage)) {
          debugPrint('is svg image: ${widget.storeData.storeAssetImage}');
          imageWidget = SvgPicture.network(
            widget.storeData.storeAssetImage,
            width: width,
            height: height,
          );
        } else {
          imageWidget = CachedNetworkImage(
            imageUrl: widget.storeData.storeAssetImage,
            width: width,
            cacheManager: networkImageCacheManager,
            height: height,
            memCacheHeight: 300,
            memCacheWidth: 300,
            fadeInDuration: const Duration(milliseconds: 10),
            fit: BoxFit.fitWidth,
            errorWidget: (context, url, error) {
              return defaultImage();
            },
          );
        }
      } catch (e, stackTrace) {
        debugPrint(
            'Error loading image: $e ~ ${widget.storeData.storeAssetImage}');
        debugPrint('Error loading image: $stackTrace');
        return defaultImage();
      }
    }
    return imageWidget;
  }

  bool _isSvgImage(String imageUrl) {
    final regex = RegExp(r'\.svg(\?|$)');
    return regex.hasMatch(imageUrl.toLowerCase());
  }
}

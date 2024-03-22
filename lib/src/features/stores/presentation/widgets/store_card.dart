import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/stores/presentation/widgets/index.dart';
import 'package:pzdeals/src/models/index.dart';

class StoreCardWidget extends ConsumerStatefulWidget {
  final StoreData storeData;
  const StoreCardWidget({super.key, required this.storeData});
  @override
  _StoreCardWidgetState createState() => _StoreCardWidgetState();
}

class _StoreCardWidgetState extends ConsumerState<StoreCardWidget> {
  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: storeIcon(),
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

  Widget storeIcon() {
    ImageProvider imageProvider;
    double width = 80;
    double height = 80;

    if (widget.storeData.assetSourceType == 'asset') {
      imageProvider = AssetImage(widget.storeData.storeAssetImage);
    } else if (widget.storeData.assetSourceType == 'network') {
      imageProvider = NetworkImage(widget.storeData.storeAssetImage);
    } else {
      imageProvider = const AssetImage('assets/pzdeals.png');
    }

    Widget imageWidget = Image(
      image: imageProvider,
      width: width,
      height: height,
      fit: BoxFit.fitWidth,
    );

    if (widget.storeData.assetSourceType == 'network') {
      imageWidget = CachedNetworkImage(
        imageUrl: widget.storeData.storeAssetImage,
        width: width,
        height: height,
        fit: BoxFit.fitWidth,
        errorWidget: (context, url, error) {
          debugPrint('Error loading image: $error');
          return Image.asset(
            'assets/images/pzdeals.png',
            width: width,
            height: height,
            fit: BoxFit.fitWidth,
          );
        },
      );
    }

    return imageWidget;
  }
}

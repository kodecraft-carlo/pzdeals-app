import 'package:flutter/material.dart';
import 'package:pzdeals/src/common_widgets/store_icon.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/stores/presentation/widgets/index.dart';
import 'package:pzdeals/src/models/index.dart';

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

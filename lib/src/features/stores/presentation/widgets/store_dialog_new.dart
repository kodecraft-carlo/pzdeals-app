import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class StoreContentDialog extends StatelessWidget {
  const StoreContentDialog({super.key, required this.storeContent});

  final Widget storeContent;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        surfaceTintColor: PZColors.pzWhite,
        backgroundColor: PZColors.pzWhite,
        shadowColor: PZColors.pzBlack,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.dialogBorderRadius),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: Sizes.paddingAllSmall),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Sizes.paddingAll),
                  child: storeContent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

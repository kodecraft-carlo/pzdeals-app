import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class ChipsWidget extends StatelessWidget {
  const ChipsWidget({super.key, required this.pillText});
  final String pillText;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(pillText),
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Sizes.cardBorderRadius)),
          side: BorderSide(color: PZColors.pzLightGrey, width: 1.0)),
      backgroundColor: PZColors.pzLightGrey, // Adjust the background color
      labelStyle:
          const TextStyle(color: PZColors.pzBlack), // Adjust the text color
    );
  }
}

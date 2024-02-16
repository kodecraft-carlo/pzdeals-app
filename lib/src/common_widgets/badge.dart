import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    super.key,
    required this.discountPercentage,
  });

  final int discountPercentage;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: PZColors.pzBadgeColor, // Badge color
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        '$discountPercentage% Off',
        style: const TextStyle(
          color: Colors.white,
          fontSize: Sizes.bodySmallSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

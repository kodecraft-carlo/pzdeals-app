import 'package:flutter/material.dart';
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
        color: discountPercentage > 0
            ? PZColors.pzBadgeColor
            : Colors.transparent, // Badge color
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        '$discountPercentage% Off',
        style: TextStyle(
          color: discountPercentage > 0 ? Colors.white : Colors.transparent,
          fontSize: Sizes.bodySmallSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

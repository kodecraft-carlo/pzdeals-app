import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class ExpiredDealBannerWidget extends StatelessWidget {
  const ExpiredDealBannerWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(Sizes.paddingAllSmall),
                decoration: BoxDecoration(
                  color: PZColors.pzOrange.withOpacity(.1),
                  borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
                ),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      const TextSpan(
                          text: 'UPDATE: ',
                          style: TextStyle(
                              color: PZColors.pzOrange,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins')),
                      TextSpan(
                          text: message,
                          style: const TextStyle(
                              color: PZColors.pzOrange, fontFamily: 'Poppins')),
                    ]))))
      ],
    );
  }
}

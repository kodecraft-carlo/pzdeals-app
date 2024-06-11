import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class SeeDealButton extends StatelessWidget {
  const SeeDealButton(
      {super.key, this.buttonLabel = 'See Deal', required this.onPressed});

  final String buttonLabel;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: FilledButton(
          style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius),
              ),
              backgroundColor: PZColors.pzGreen,
              elevation: Sizes.buttonElevation),
          onPressed: () {
            onPressed();
          },
          child: Text(
            buttonLabel,
            style: const TextStyle(color: PZColors.pzWhite),
          ),
        )),
      ],
    );
  }
}

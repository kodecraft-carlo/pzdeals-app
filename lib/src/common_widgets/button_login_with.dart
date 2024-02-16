import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class ButtonLoginWith extends StatelessWidget {
  const ButtonLoginWith(
      {super.key,
      required this.buttonLabel,
      required this.imageAsset,
      required this.onButtonPressed});

  final String buttonLabel;
  final String imageAsset;
  final VoidCallback onButtonPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          onButtonPressed();
        },
        style: ButtonStyle(
          side: MaterialStateBorderSide.resolveWith(
              (states) => const BorderSide(color: PZColors.pzBlack)),
          surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: MaterialStateProperty.all(PZColors.pzWhite),
          overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(.1)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(
                  horizontal: Sizes.paddingAll,
                  vertical: Sizes.paddingAll / 1.5)),
          shape:
              MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Sizes.buttonBorderRadius,
            ),
          )),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  imageAsset,
                  height: Sizes.buttonImageHeight,
                  fit: BoxFit.fitHeight,
                )),
            Text(
              buttonLabel,
              style: const TextStyle(color: PZColors.pzBlack),
            ),
          ],
        ));
  }
}

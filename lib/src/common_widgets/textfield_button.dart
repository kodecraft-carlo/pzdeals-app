import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class TextFieldButton extends StatelessWidget {
  const TextFieldButton(
      {super.key,
      required this.onButtonPressed,
      required this.buttonLabel,
      required this.textFieldHint,
      this.textfieldIcon = Icons.search,
      this.hasIcon = true,
      this.isAutoFocus = false});

  final VoidCallback onButtonPressed;
  final String buttonLabel;
  final String textFieldHint;
  final IconData textfieldIcon;
  final bool hasIcon;
  final bool isAutoFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      height: 44,
      padding: const EdgeInsets.only(left: Sizes.paddingLeftSmall),
      decoration: BoxDecoration(
          border: Border.all(color: PZColors.pzGrey.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(Sizes.textFieldCornerRadius),
          color: PZColors.pzLightGrey),
      child: Row(
        children: [
          if (hasIcon)
            Icon(
              textfieldIcon,
              color: PZColors.pzOrange,
              size: Sizes.textFieldIconSize,
            ),
          Expanded(
            child: TextField(
              autofocus: isAutoFocus,
              decoration: InputDecoration(
                hintText: textFieldHint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: Sizes.paddingAllSmall),
              ),
              style: const TextStyle(
                  fontSize: Sizes.textFieldFontSize, color: PZColors.pzBlack),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(PZColors.pzOrange),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: Sizes.paddingAll)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Sizes.textFieldCornerRadius),
                    bottomRight: Radius.circular(Sizes.textFieldCornerRadius)),
              )),
            ),
            onPressed: onButtonPressed,
            child: Text(
              buttonLabel,
              style: const TextStyle(color: PZColors.pzWhite),
            ),
          ),
          const SizedBox(width: 1)
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class TextFieldButton extends StatefulWidget {
  const TextFieldButton(
      {super.key,
      required this.onButtonPressed,
      required this.buttonLabel,
      required this.textFieldHint,
      this.textfieldIcon = Icons.search,
      this.hasIcon = true,
      this.isAutoFocus = false,
      required this.textController});

  final VoidCallback onButtonPressed;
  final String buttonLabel;
  final String textFieldHint;
  final IconData textfieldIcon;
  final bool hasIcon;
  final bool isAutoFocus;
  final TextEditingController textController;

  @override
  _TextFieldButtonState createState() => _TextFieldButtonState();
}

class _TextFieldButtonState extends State<TextFieldButton> {
  bool isActionEnabled = false;
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
          if (widget.hasIcon)
            Icon(
              widget.textfieldIcon,
              color: PZColors.pzOrange,
              size: Sizes.textFieldIconSize,
            ),
          Expanded(
            child: TextField(
              autofocus: widget.isAutoFocus,
              controller: widget.textController,
              onChanged: (value) {
                setState(() {
                  isActionEnabled = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: widget.textFieldHint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: Sizes.paddingAllSmall),
                suffixIcon: widget.textController.text.isNotEmpty
                    ? GestureDetector(
                        child: const Icon(Icons.cancel, color: PZColors.pzGrey),
                        onTap: () {
                          widget.textController.clear();
                          setState(() {
                            isActionEnabled = false;
                          });
                        },
                      )
                    : null,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                ),
              ),
              style: const TextStyle(
                  fontSize: Sizes.textFieldFontSize, color: PZColors.pzBlack),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: !isActionEnabled
                  ? MaterialStateProperty.all<Color>(PZColors.pzGrey)
                  : MaterialStateProperty.all<Color>(PZColors.pzOrange),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: Sizes.paddingAll)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Sizes.textFieldCornerRadius),
                    bottomRight: Radius.circular(Sizes.textFieldCornerRadius)),
              )),
            ),
            onPressed: !isActionEnabled || widget.textController.text.isEmpty
                ? null
                : widget.onButtonPressed,
            child: Text(
              widget.buttonLabel,
              style: const TextStyle(color: PZColors.pzWhite),
            ),
          ),
          const SizedBox(width: 1)
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget(
      {super.key,
      required this.hintText,
      this.textValue = '',
      this.destinationScreen,
      this.autoFocus = false});

  final String hintText;
  final String textValue;
  final Widget? destinationScreen;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    TextEditingController textController =
        TextEditingController(text: textValue);

    return TextField(
      autofocus: autoFocus,
      controller: textController,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: PZColors.pzOrange,
          size: Sizes.textFieldIconSize,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
        ),
        hintText: hintText,
        fillColor: PZColors.pzGrey.withOpacity(0.125),
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.textFieldCornerRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(Sizes.paddingAllSmall),
      ),
      style: const TextStyle(
          fontSize: Sizes.textFieldFontSize, color: PZColors.pzBlack),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        if (destinationScreen != null && value.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => destinationScreen!,
            settings:
                RouteSettings(arguments: value), // Pass the value as arguments
          ));
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}

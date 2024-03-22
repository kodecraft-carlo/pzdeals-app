import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/state/provider_search.dart';

class SearchFieldWidget extends StatefulWidget {
  const SearchFieldWidget(
      {super.key,
      required this.hintText,
      this.textValue = '',
      this.destinationScreen,
      this.autoFocus = false,
      this.onSubmitted});

  final String hintText;
  final String textValue;
  final Widget? destinationScreen;
  final bool autoFocus;
  final VoidCallback? onSubmitted;
  @override
  SearchFieldWidgetState createState() => SearchFieldWidgetState();
}

class SearchFieldWidgetState extends State<SearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textController =
        TextEditingController(text: widget.textValue);

    return Consumer(builder: (context, ref, child) {
      return TextField(
        autofocus: widget.autoFocus,
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
          hintText: widget.hintText,
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
          if (value.isEmpty) return;
          ref.read(searchproductProvider).setSearchKey(value);
          if (widget.onSubmitted != null) {
            widget.onSubmitted!();
          } else {
            if (value.isNotEmpty && widget.destinationScreen != null) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => widget.destinationScreen!,
                settings: RouteSettings(arguments: value),
              ));
            }
          }

          FocusScope.of(context).unfocus();
        },
      );
    });
  }
}

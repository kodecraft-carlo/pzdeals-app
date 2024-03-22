import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class StoreSearchFieldWidget extends StatefulWidget {
  const StoreSearchFieldWidget({
    super.key,
    required this.hintText,
    this.textValue = '',
    this.destinationScreen,
    this.autoFocus = false,
    required this.filterStores,
    required this.storeNames,
  });

  final String hintText;
  final String textValue;
  final Widget? destinationScreen;
  final bool autoFocus;

  final Function(String) filterStores;
  final List<String> storeNames;
  @override
  _StoreSearchFieldWidgetState createState() => _StoreSearchFieldWidgetState();
}

class _StoreSearchFieldWidgetState extends State<StoreSearchFieldWidget> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }

          return widget.storeNames.where((String option) {
            return option
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Material(
                elevation: 4.0,
                surfaceTintColor: Colors.transparent,
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(Sizes.containerBorderRadius)),
                ),
                child: SizedBox(
                  height: options.length * 52.0,
                  width: constraints.maxWidth,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
        onSelected: (String selection) {
          searchController.text = selection;
          widget.filterStores(selection);
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            onSubmitted: (String value) {
              onFieldSubmitted();
            },
            onChanged: widget.filterStores,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: PZColors.pzOrange,
                size: Sizes.textFieldIconSize,
              ),
              suffixIcon: textEditingController.text.isNotEmpty
                  ? GestureDetector(
                      child: const Icon(Icons.cancel, color: PZColors.pzGrey),
                      onTap: () {
                        textEditingController.clear();
                        widget.filterStores('');
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
              hintText: widget.hintText,
              fillColor: PZColors.pzGrey.withOpacity(0.125),
              filled: true,
              isDense: true,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 40,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(Sizes.textFieldCornerRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(Sizes.paddingAllSmall),
            ),
            style: const TextStyle(
              fontSize: Sizes.textFieldFontSize,
              color: PZColors.pzBlack,
            ),
            textInputAction: TextInputAction.search,
          );
          // return TextField(
          //   autofocus: widget.autoFocus,
          //   controller: searchController,
          //   onChanged: widget.filterStores,
          //   decoration: InputDecoration(
          //     prefixIcon: const Icon(
          //       Icons.search,
          //       color: PZColors.pzOrange,
          //       size: Sizes.textFieldIconSize,
          //     ),
          //     suffixIcon: searchController.text.isNotEmpty
          //         ? GestureDetector(
          //             child: const Icon(Icons.cancel, color: PZColors.pzGrey),
          //             onTap: () {
          //               searchController.clear();
          //               widget.filterStores('');
          //             },
          //           )
          //         : null,
          //     hintText: widget.hintText,
          //     fillColor: PZColors.pzGrey.withOpacity(0.125),
          //     filled: true,
          //     isDense: true,
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(Sizes.textFieldCornerRadius),
          //       borderSide: BorderSide.none,
          //     ),
          //     contentPadding: const EdgeInsets.all(Sizes.paddingAllSmall),
          //   ),
          //   style: const TextStyle(
          //     fontSize: Sizes.textFieldFontSize,
          //     color: PZColors.pzBlack,
          //   ),
          //   textInputAction: TextInputAction.search,
          // );
        },
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class StoreSearchFieldWidget extends StatelessWidget {
  const StoreSearchFieldWidget({
    super.key,
    required this.hintText,
    this.textValue = '',
    this.destinationScreen,
    this.autoFocus = false,
    required this.searchController,
    required this.filterStores,
  });

  final String hintText;
  final String textValue;
  final Widget? destinationScreen;
  final bool autoFocus;
  final TextEditingController searchController;
  final Function(String) filterStores;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      controller: searchController,
      onChanged: filterStores, // Call filterStores when text changes
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: PZColors.pzOrange,
          size: Sizes.textFieldIconSize,
        ),
        suffixIcon: searchController.text.isNotEmpty
            ? GestureDetector(
                child: const Icon(Icons.cancel, color: PZColors.pzGrey),
                onTap: () {
                  searchController.clear();
                  filterStores('');
                },
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
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
        fontSize: Sizes.textFieldFontSize,
        color: PZColors.pzBlack,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        if (destinationScreen != null && value.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => destinationScreen!,
            settings: RouteSettings(arguments: value),
          ));
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pzdeals/src/constants/index.dart';

class StoreSearchFieldWidget extends StatefulWidget {
  const StoreSearchFieldWidget(
      {super.key,
      required this.hintText,
      this.textValue = '',
      this.destinationScreen,
      this.autoFocus = false,
      required this.searchController,
      required this.filterStores,
      required this.storeNames});

  final String hintText;
  final String textValue;
  final Widget? destinationScreen;
  final bool autoFocus;
  final TextEditingController searchController;
  final Function(String) filterStores;
  final List<String> storeNames;
  @override
  _StoreSearchFieldWidgetState createState() => _StoreSearchFieldWidgetState();
}

class _StoreSearchFieldWidgetState extends State<StoreSearchFieldWidget> {
  String _matchingOption = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          autofocus: widget.autoFocus,
          controller: widget.searchController,
          textCapitalization: TextCapitalization.none,
          inputFormatters: [LowerCaseTextFormatter()],
          onChanged: (value) {
            widget.filterStores(value);
            setState(() {
              _matchingOption = widget.storeNames
                  .firstWhere(
                    (option) =>
                        option.toLowerCase().startsWith(value.toLowerCase()),
                    orElse: () => '',
                  )
                  .toLowerCase();
            });
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: PZColors.pzOrange,
              size: Sizes.textFieldIconSize,
            ),
            suffixIcon: widget.searchController.text.isNotEmpty
                ? GestureDetector(
                    child: const Icon(Icons.cancel, color: PZColors.pzGrey),
                    onTap: () {
                      setState(() {
                        _matchingOption = '';
                      });
                      widget.searchController.clear();
                      widget.filterStores('');
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    },
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 40,
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
              fontSize: Sizes.textFieldFontSize,
              color: PZColors.pzBlack,
              letterSpacing: 1),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            if (widget.destinationScreen != null && value.isNotEmpty) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => widget.destinationScreen!,
                settings: RouteSettings(arguments: value),
              ));
              FocusScope.of(context).unfocus();
            }
          },
        ),
        if (_matchingOption != '' && widget.searchController.text != '')
          Positioned(
            top: 1,
            left: 41,
            child: GestureDetector(
              onTap: () {
                // Autofill the TextField when the overlay text is tapped
                setState(() {
                  widget.searchController.text = _matchingOption;
                  widget.filterStores(widget.searchController.text);
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: Sizes.paddingAllSmall),
                child: Text(
                  _matchingOption,
                  style: const TextStyle(
                      color: PZColors.pzBlack,
                      fontSize: Sizes.textFieldFontSize,
                      letterSpacing: 1),
                ),
              ),
            ),
          )
      ],
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}

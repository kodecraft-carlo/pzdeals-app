import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class BlogSearchFieldWidget extends StatefulWidget {
  const BlogSearchFieldWidget({
    super.key,
    required this.hintText,
    this.textValue = '',
    this.destinationScreen,
    this.autoFocus = false,
    required this.searchController,
    required this.filterData,
  });

  final String hintText;
  final String textValue;
  final Widget? destinationScreen;
  final bool autoFocus;
  final TextEditingController searchController;
  final Function(String) filterData;

  @override
  _BlogSearchFieldWidgetState createState() => _BlogSearchFieldWidgetState();
}

class _BlogSearchFieldWidgetState extends State<BlogSearchFieldWidget> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: widget.autoFocus,
              controller: widget.searchController,
              onChanged: widget.filterData,
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
                          widget.searchController.clear();
                          widget.filterData('');
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
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: SizedBox(
              width: _isFocused ? null : 0.0,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final parentWidth = constraints.maxWidth;
                    return parentWidth > 0
                        ? GestureDetector(
                            onTap: () {
                              widget.searchController.clear();
                              widget.filterData('');
                              FocusScope.of(context).unfocus();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Sizes.paddingAllSmall),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: PZColors.pzOrange,
                                    fontSize: Sizes.textFieldFontSize,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

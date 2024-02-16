import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class ContentDialog extends StatefulWidget {
  final Widget content;

  const ContentDialog({Key? key, required this.content}) : super(key: key);

  @override
  _ContentDialogState createState() => _ContentDialogState();
}

class _ContentDialogState extends State<ContentDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _showShadow = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    setState(() {
      _showShadow = _scrollController.offset > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        surfaceTintColor: PZColors.pzWhite,
        backgroundColor: PZColors.pzWhite,
        shadowColor: PZColors.pzBlack,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.dialogBorderRadius),
        ),
        child: SizedBox(
          height: Sizes.dialogHeight,
          child: Column(
            children: [
              Material(
                surfaceTintColor: PZColors.pzWhite,
                color: PZColors.pzWhite,
                elevation: _showShadow ? 2 : 0, // Apply elevation conditionally
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: Sizes.largeIconSize,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                  height: Sizes.spaceBetweenContentSmall), // Add some padding
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: Sizes.paddingBottomSmall),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Sizes.paddingLeft,
                        right: Sizes.paddingRight,
                        bottom: Sizes.paddingBottom,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.content,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

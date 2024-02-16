import 'package:flutter/material.dart';
import 'package:pzdeals/src/common_widgets/textfield_button.dart';
import 'package:pzdeals/src/constants/index.dart';

class StoreInputDialog extends StatelessWidget {
  const StoreInputDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      backgroundColor: PZColors.pzWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(), // Pushes the icon to the right
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
      contentPadding: const EdgeInsets.only(
        left: Sizes.paddingAll,
        right: Sizes.paddingAll,
        bottom: Sizes.paddingAll,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Don't see your favorite store? Submit it herse!",
            style: TextStyle(
              fontSize: Sizes.fontSizeMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Sizes.paddingBottomSmall),
          TextFieldButton(
            onButtonPressed: () {
              Navigator.of(context).pop();
              debugPrint("submitted");
            },
            buttonLabel: 'Submit',
            textFieldHint: 'Store name or website..',
            hasIcon: false,
            isAutoFocus: true,
          ),
        ],
      ),
    );
  }
}

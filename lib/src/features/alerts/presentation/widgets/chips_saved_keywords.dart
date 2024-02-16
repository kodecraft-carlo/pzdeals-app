import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

enum EditMode { edit, view }

class ChipSavedKeywords extends StatelessWidget {
  const ChipSavedKeywords({
    super.key,
    required this.savedKeywordsData,
    this.editMode = EditMode.view,
  });

  final List<String> savedKeywordsData;
  final EditMode editMode;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300), // Set your desired duration
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        );
      },
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5.0,
        children: savedKeywordsData.map(
          (String pillText) {
            if (editMode == EditMode.edit) {
              return InputChip(
                key: ValueKey('InputChip$pillText'),
                label: Text(pillText),
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                clipBehavior: Clip.hardEdge,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Sizes.cardBorderRadius),
                  ),
                  side: BorderSide(
                    color: PZColors.pzLightGrey,
                    width: 1.0,
                  ),
                ),
                backgroundColor: PZColors.pzLightGrey,
                labelStyle: const TextStyle(
                    color: PZColors.pzBlack, fontSize: Sizes.bodyFontSize),
                deleteIcon: const Icon(
                  Icons.cancel,
                  size: Sizes.regularIconSize,
                  color: PZColors.pzGrey,
                ),
                onDeleted: () {
                  // Implement your delete action here
                },
              );
            } else {
              return Chip(
                key: ValueKey('Chip$pillText'),
                label: Text(pillText),
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Sizes.cardBorderRadius),
                  ),
                  side: BorderSide(
                    color: PZColors.pzLightGrey,
                    width: 1.0,
                  ),
                ),
                backgroundColor: PZColors.pzLightGrey,
                labelStyle: const TextStyle(
                    color: PZColors.pzBlack, fontSize: Sizes.bodyFontSize),
              );
            }
          },
        ).toList(),
      ),
    );
  }
}

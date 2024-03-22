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
            return InputChip(
              key: ValueKey('InputChip$pillText'),
              label: Text(
                pillText,
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: editMode == EditMode.edit ? 0 : 5.0,
              ),
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
              disabledColor: PZColors.pzLightGrey,
              labelStyle: const TextStyle(
                  color: PZColors.pzBlack, fontSize: Sizes.bodyFontSize),
              deleteIcon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: editMode == EditMode.edit
                      ? const Icon(
                          Icons.cancel,
                          size: Sizes.regularIconSize,
                          color: PZColors.pzGrey,
                        )
                      : null),
              onDeleted: () {
                // Implement your delete action here
              },
            );
          },
        ).toList(),
      ),
    );
  }
}

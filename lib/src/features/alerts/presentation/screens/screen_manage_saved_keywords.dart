import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/custom_scaffold.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/alerts/state/keyword_provider.dart';

class ManageSavedKeywordScreen extends ConsumerStatefulWidget {
  const ManageSavedKeywordScreen({super.key});

  @override
  ManageSavedKeywordScreenState createState() =>
      ManageSavedKeywordScreenState();
}

class ManageSavedKeywordScreenState
    extends ConsumerState<ManageSavedKeywordScreen> {
  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    final savedKeywordData =
        ref.watch(keywordsProvider.select((value) => value.savedkeywords));

    if (savedKeywordData.isEmpty) {
      isEditMode = false;
    }
    debugPrint('screen alerts management build');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(
              top: Sizes.paddingTopSmall,
              left: Sizes.paddingLeft,
              right: Sizes.paddingRight),
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manage Keywords",
                          style: TextStyle(
                              fontSize: Sizes.headerFontSize,
                              fontWeight: FontWeight.w600,
                              color: PZColors.pzBlack),
                        ),
                        Text(
                          "Tap on edit to remove keywords",
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: Sizes.bodyFontSize,
                              fontWeight: FontWeight.w400,
                              color: PZColors.pzBlack),
                        ),
                      ],
                    ),
                  ),
                  savedKeywordData.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              isEditMode = !isEditMode;
                            });
                          },
                          child: Text(isEditMode ? "Done" : "Edit",
                              style: const TextStyle(
                                  fontSize: Sizes.fontSizeMedium,
                                  fontWeight: FontWeight.w600,
                                  color: PZColors.pzOrange)),
                        )
                      : const SizedBox.shrink()
                ],
              ),
              const SizedBox(
                height: Sizes.spaceBetweenSections,
              ),
              savedKeywordData.isNotEmpty
                  ? Row(children: [
                      Expanded(
                        child: RawScrollbar(
                            controller: scrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: ChipSavedKeywords(
                                editMode:
                                    isEditMode ? EditMode.edit : EditMode.view,
                              ),
                            )),
                      )
                    ])
                  : const Center(
                      child: Text(
                        'You have no saved keywords yet.',
                        style: TextStyle(
                            color: PZColors.pzGrey,
                            fontStyle: FontStyle.italic,
                            fontSize: Sizes.fontSizeSmall),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ]),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/common_widgets/textfield_button.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/grid_popularkeywords.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/alerts/state/keyword_provider.dart';

class AlertsManagementScreen extends ConsumerStatefulWidget {
  const AlertsManagementScreen({super.key});

  @override
  _AlertsManagementScreenState createState() => _AlertsManagementScreenState();
}

class _AlertsManagementScreenState
    extends ConsumerState<AlertsManagementScreen> {
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  bool isEditMode = false;
  bool _showMore = false;

  @override
  void initState() {
    super.initState();
    // filteredStores = [];
    Future(() {
      ref.read(keywordsProvider).loadSavedKeywords();
      ref.read(keywordsProvider).loadPopularKeywords();
    });
  }

  void onButtonPressed() {
    if (textController.text.isNotEmpty) {
      if (ref.read(keywordsProvider).addKeywordLocally(
          KeywordData(id: 0, keyword: textController.text.trim().toLowerCase()),
          'input')) {
        showSnackbarWithMessage(context, 'Keyword added');
        textController.clear();
      } else {
        showSnackbarWithMessage(context, 'Keyword already exists');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keywordState = ref.watch(keywordsProvider);
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     _showMore = scrollController.position.maxScrollExtent > 0;
    //   });
    // });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: Sizes.paddingTopSmall,
          left: Sizes.paddingLeft,
          right: Sizes.paddingRight,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Deal Alert",
                style: TextStyle(
                    fontSize: Sizes.headerFontSize,
                    fontWeight: FontWeight.w600,
                    color: PZColors.pzBlack),
              ),
              const Text(
                "Subscribe to keyword alerts and get notified on new matching deals",
                style: TextStyle(
                    fontSize: Sizes.bodyFontSize,
                    fontWeight: FontWeight.w400,
                    color: PZColors.pzBlack),
              ),
              const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Saved Keywords",
                          style: TextStyle(
                              fontSize: Sizes.fontSizeMedium,
                              fontWeight: FontWeight.w600,
                              color: PZColors.pzBlack)),
                      !keywordState.isLoading &&
                              keywordState.savedkeywords.isNotEmpty
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
                  const SizedBox(height: Sizes.spaceBetweenContentSmall),
                  keywordState.savedkeywords.isNotEmpty
                      ? Row(children: [
                          Expanded(
                              child: SizedBox(
                            height: 120,
                            child: RawScrollbar(
                                controller: scrollController,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: ChipSavedKeywords(
                                    editMode: isEditMode
                                        ? EditMode.edit
                                        : EditMode.view,
                                  ),
                                )),
                          ))
                        ])
                      : const SizedBox(
                          height: 120,
                          child: Text(
                            'You have no saved keywords yet.',
                            style: TextStyle(
                                color: PZColors.pzGrey,
                                fontStyle: FontStyle.italic,
                                fontSize: Sizes.fontSizeSmall),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  const SizedBox(height: Sizes.spaceBetweenSectionsXL),
                  TextFieldButton(
                    textController: textController,
                    onButtonPressed: onButtonPressed,
                    buttonLabel: 'Create',
                    textFieldHint: 'Enter Keyword',
                    textfieldIcon: Icons.search,
                  ),
                  const SizedBox(height: Sizes.spaceBetweenSectionsXL),
                  const Text("Popular Keywords",
                      style: TextStyle(
                          fontSize: Sizes.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                          color: PZColors.pzBlack)),
                  const Text(
                    "Click on the plus sign to subscribe",
                    style: TextStyle(
                        fontSize: Sizes.bodyFontSize,
                        fontWeight: FontWeight.w400,
                        color: PZColors.pzBlack),
                  ),
                  PopularKeywordsGrid(
                      keywordsdata: keywordState.popularKeywords)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

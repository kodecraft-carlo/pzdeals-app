import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:pzdeals/src/common_widgets/bouncing_arrow_down.dart';
import 'package:pzdeals/src/common_widgets/textfield_button.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/grid_popularkeywords.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/index.dart';

class AlertsManagementScreen extends StatefulWidget {
  const AlertsManagementScreen(
      {super.key, required this.savedKeywords, required this.popularKeywords});

  final List<String> savedKeywords;
  final List<PopularKeywordData> popularKeywords;

  @override
  _AlertsManagementScreenState createState() => _AlertsManagementScreenState();
}

class _AlertsManagementScreenState extends State<AlertsManagementScreen> {
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  bool isEditMode = false;
  bool _showMore = false;

  get savedKeywords => widget.savedKeywords;
  get popularKeywords => widget.popularKeywords;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showMore = scrollController.position.maxScrollExtent > 0;
      });
    });
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
                      GestureDetector(
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
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceBetweenContentSmall),
                  Container(
                    height: 3 * 50,
                    child: RawScrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        radius: const Radius.circular(10),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: ChipSavedKeywords(
                            savedKeywordsData: savedKeywords,
                            editMode:
                                isEditMode ? EditMode.edit : EditMode.view,
                          ),
                        )),
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
                  PopularKeywordsGrid(keywordsdata: popularKeywords)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void onButtonPressed() {
    debugPrint("Create Button Pressed");
  }
}

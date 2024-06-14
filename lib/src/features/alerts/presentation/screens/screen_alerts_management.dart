import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/screens/screen_manage_saved_keywords.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/create_alert_field_button.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/grid_popularkeywords.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/list_categorytoggles.dart';
import 'package:pzdeals/src/features/alerts/state/keyword_provider.dart';

class AlertsManagementScreen extends ConsumerStatefulWidget {
  const AlertsManagementScreen({super.key});

  @override
  AlertsManagementScreenState createState() => AlertsManagementScreenState();
}

class AlertsManagementScreenState
    extends ConsumerState<AlertsManagementScreen> {
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController(keepScrollOffset: true);

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future(() {
      // ref.read(keywordsProvider).loadSavedKeywords();
      ref.read(keywordsProvider).loadPopularKeywords();
    });
  }

  void scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('screen alerts management build');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
            top: Sizes.paddingTopSmall,
            left: Sizes.paddingLeft,
            right: Sizes.paddingRight),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            scrollToTop();
                          },
                          child: const Text(
                            "Create Deal Alerts",
                            style: TextStyle(
                                fontSize: Sizes.headerFontSize,
                                fontWeight: FontWeight.w600,
                                color: PZColors.pzBlack),
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: true,
                          showDragHandle: true,
                          useSafeArea: true,
                          builder: (context) => buildSheet(context));
                    },
                    child: const Text("Manage keywords",
                        style: TextStyle(
                            fontSize: Sizes.fontSizeMedium,
                            fontWeight: FontWeight.w600,
                            color: PZColors.pzOrange)),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                Wordings.descDealAlerts,
                style: TextStyle(
                    fontSize: Sizes.bodyFontSize,
                    fontWeight: FontWeight.w400,
                    color: PZColors.pzBlack),
              ),
              const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              CreateAlertFieldButton(
                textController: textController,
                buttonLabel: 'Create',
                textFieldHint: 'Add keyword, store, category, brand..',
                textfieldIcon: Icons.search,
              ),
              const SizedBox(height: Sizes.spaceBetweenSections),
              const Center(
                child: Text(
                  "Top Deal Alerts",
                  style: TextStyle(
                      fontSize: Sizes.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                      color: PZColors.pzBlack),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: Sizes.spaceBetweenContent),
              const Divider(
                thickness: 1,
                color: PZColors.pzOrange,
                height: 1,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: const Column(
                    children: [
                      SizedBox(height: Sizes.spaceBetweenContent),
                      PopularKeywordsGrid()
                    ],
                  ),
                ),
              )
            ]),
      ),
    );
  }

  Widget buildSheet(context) => const ManageSavedKeywordScreen();
}

import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/material_navigate_screen.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/chips_saved_keywords.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';

class KeywordAlertsSection extends StatelessWidget {
  const KeywordAlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Keyword Alerts",
          style: TextStyle(
              fontSize: Sizes.sectionHeaderFontSize,
              fontWeight: FontWeight.w600,
              color: PZColors.pzBlack),
        ),
        Text(
            "You will receive notification when there are deals that match these keywords",
            style: TextStyle(
                fontSize: Sizes.listSubtitleFontSize, color: PZColors.pzBlack)),
        ChipSavedKeywords(
          editMode: EditMode.view,
        ),
        SizedBox(height: Sizes.spaceBetweenContent),
        MaterialNavigateScreen(
            childWidget: Text('Manage Keywords',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: Sizes.bodyFontSize,
                    color: PZColors.pzOrange,
                    fontWeight: FontWeight.w600)),
            destinationScreen: NavigationWidget(
              initialPageIndex: 3,
            ))
      ],
    );
  }
}

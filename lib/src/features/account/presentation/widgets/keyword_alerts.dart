import 'package:flutter/material.dart';
import 'package:pzdeals/main.dart';
import 'package:pzdeals/src/actions/material_navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/chips.dart';
import 'package:pzdeals/src/constants/index.dart';

class KeywordAlertsSection extends StatelessWidget {
  const KeywordAlertsSection({super.key, required this.savedKeywords});

  final List<String> savedKeywords;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Keyword Alerts",
          style: TextStyle(
              fontSize: Sizes.sectionHeaderFontSize,
              fontWeight: FontWeight.w600,
              color: PZColors.pzBlack),
        ),
        const Text(
            "You will receive notification when there are deals that match these keywords",
            style: TextStyle(
                fontSize: Sizes.listSubtitleFontSize, color: PZColors.pzBlack)),
        Wrap(
          spacing: 8.0,
          runSpacing: 1.0,
          children: savedKeywords.map((String pillText) {
            return ChipsWidget(pillText: pillText);
          }).toList(),
        ),
        const SizedBox(height: Sizes.spaceBetweenContent),
        const MaterialNavigateScreen(
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

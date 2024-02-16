import 'package:flutter/material.dart';
import 'package:pzdeals/main.dart';
import 'package:pzdeals/src/actions/material_navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/chips.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_result.dart';

class SearchKeyWords extends StatelessWidget {
  SearchKeyWords({super.key});
  final List<String> pills = [
    'Airpods',
    'iPhone',
    'Nike Panda',
    'Apple Watch series 9',
    'New Balance 550',
    'Veja CWL V-10',
    'JBL Speaker',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Saved Keywords",
                  style: TextStyle(
                      fontSize: Sizes.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                      color: PZColors.pzBlack)),
              MaterialNavigateScreen(
                  childWidget: Text("Manage",
                      style: TextStyle(
                          fontSize: Sizes.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                          color: PZColors.pzOrange)),
                  destinationScreen: NavigationWidget(
                    initialPageIndex: 3,
                  ))
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 1.0,
                  children: pills.map((String pillText) {
                    return MaterialNavigateScreen(
                        childWidget: ChipsWidget(pillText: pillText),
                        destinationScreen: SearchResultScreen(
                          searchKey: pillText,
                        ));
                  }).toList(),
                ),
              )
            ],
          )
        ]);
  }
}

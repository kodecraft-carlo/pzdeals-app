import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/widgets/index.dart';

class PopularKeywordsGrid extends StatelessWidget {
  const PopularKeywordsGrid({super.key, required this.keywordsdata});

  final List<PopularKeywordData> keywordsdata;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 3;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: Sizes.paddingAllSmall),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: itemWidth,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 2 / 2.6),
      itemCount: keywordsdata.length,
      itemBuilder: (context, index) {
        final keyword = keywordsdata[index];
        return PopularKeywordsCard(
            imagePath: keyword.image, text: keyword.keyword);
      },
    );
  }
}

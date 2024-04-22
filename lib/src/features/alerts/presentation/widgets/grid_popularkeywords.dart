import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/alerts/state/keyword_provider.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';

class PopularKeywordsGrid extends StatelessWidget {
  const PopularKeywordsGrid({super.key, required this.keywordsdata});

  final List<KeywordData> keywordsdata;

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
        childAspectRatio: 2 / 2.6,
      ),
      itemCount: keywordsdata.length > 12 ? 12 : keywordsdata.length,
      itemBuilder: (context, index) {
        final keyword = keywordsdata[index];
        return PopularKeywordsCard(
          keywordData: keyword,
        );
      },
    );
  }
}

class PopularKeywordsCard extends ConsumerStatefulWidget {
  final KeywordData keywordData;

  const PopularKeywordsCard({super.key, required this.keywordData});

  @override
  PopularKeywordsCardState createState() => PopularKeywordsCardState();
}

class PopularKeywordsCardState extends ConsumerState<PopularKeywordsCard> {
  bool _isAdded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(Sizes.paddingAllSmall / 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
        border: Border.all(
          color: PZColors.pzLightGrey,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (ref
                  .read(keywordsProvider)
                  .addKeywordLocally(widget.keywordData, 'popular')) {
                setState(() {
                  _isAdded = true;
                });

                showSnackbarWithMessage(context, 'Keyword added');
                Future.delayed(const Duration(seconds: 1), () {
                  setState(() {
                    _isAdded = false;
                  });
                });
              } else {
                showSnackbarWithMessage(context, 'Keyword already exists');
              }
            },
            child: Align(
                alignment: Alignment.topRight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: _isAdded
                      ? const Icon(
                          Icons.check_circle,
                          key: ValueKey('checkIcon'),
                          color: PZColors.pzGreen,
                        )
                      : const Icon(
                          Icons.add_circle,
                          key: ValueKey('plusIcon'),
                          color: PZColors.pzOrange,
                        ),
                )),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
              child: CachedNetworkImage(
                imageUrl: widget.keywordData.imageUrl,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) {
                  debugPrint('Error loading image: $error');
                  return Image.asset(
                    'assets/images/pzdeals.png',
                    fit: BoxFit.fitWidth,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: Sizes.paddingAllSmall),
            child: Text(
              widget.keywordData.keyword,
              style: const TextStyle(
                color: PZColors.pzBlack,
                fontWeight: FontWeight.w500,
                fontSize: Sizes.bodyFontSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}

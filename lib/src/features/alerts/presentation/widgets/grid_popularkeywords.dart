import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/alerts/models/keyword_data.dart';
import 'package:pzdeals/src/features/alerts/state/keyword_provider.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/utils/storage/network_image_cache_manager.dart';

class PopularKeywordsGrid extends ConsumerWidget {
  const PopularKeywordsGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keywordState = ref.watch(keywordsProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 3;
    final List<KeywordData> keywordsdata = keywordState.popularKeywords;
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
    final keywordState = ref.watch(keywordsProvider);
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
              if (keywordState.addKeywordLocally(
                  widget.keywordData, 'popular')) {
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
                cacheManager: networkImageCacheManager,
                fit: BoxFit.contain,
                fadeInDuration: const Duration(milliseconds: 10),
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

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
    final popularKeywords =
        ref.watch(keywordsProvider.select((value) => value.popularKeywords));
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 3;
    final List<KeywordData> keywordsdata = popularKeywords;
    if (popularKeywords.isEmpty && !ref.watch(keywordsProvider).isLoading) {
      return SizedBox(
        width: double.infinity,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No popular keywords found.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Sizes.fontSizeMedium, color: PZColors.pzGrey),
            ),
            const SizedBox(height: Sizes.spaceBetweenContentSmall),
            FilledButton(
                onPressed: () {
                  ref.read(keywordsProvider).loadPopularKeywords();
                },
                style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(PZColors.pzOrange),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Sizes.buttonBorderRadius,
                      ),
                    ))),
                child: const Text(
                  'Refresh',
                ))
          ],
        ),
      );
    }
    if (ref.watch(keywordsProvider).isLoading && popularKeywords.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
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

  void addKeyword(KeywordData keywordData, BuildContext context) {
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
  }

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
              addKeyword(widget.keywordData, context);
              // setState(() {
              //   _isAdded = !_isAdded;
              // });
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
                memCacheHeight: 250,
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

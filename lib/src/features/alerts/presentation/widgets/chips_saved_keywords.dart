import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/alerts/state/keyword_provider.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_result.dart';

enum EditMode { edit, view }

class ChipSavedKeywords extends ConsumerStatefulWidget {
  const ChipSavedKeywords({
    super.key,
    this.editMode = EditMode.view,
    this.enableSearch = false,
  });
  final EditMode editMode;
  final bool enableSearch;
  @override
  ChipSavedKeywordsState createState() => ChipSavedKeywordsState();
}

class ChipSavedKeywordsState extends ConsumerState<ChipSavedKeywords> {
  @override
  void initState() {
    super.initState();
    // Future(() {
    //   ref.read(keywordsProvider).loadSavedKeywords();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final savedKeywords =
        ref.watch(keywordsProvider.select((value) => value.savedkeywords));
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 5.0,
      children: savedKeywords.map(
        (KeywordData keyword) {
          return InputChip(
            key: ValueKey('InputChip${keyword.keyword}'),
            label: Text(
              keyword.keyword,
              textAlign: TextAlign.center,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Sizes.cardBorderRadius),
              ),
              side: BorderSide(
                color: PZColors.pzLightGrey,
                width: 1.0,
              ),
            ),
            backgroundColor: PZColors.pzLightGrey,
            disabledColor: PZColors.pzLightGrey,
            onPressed: () => {
              if (widget.enableSearch)
                {
                  debugPrint('Search for keyword: ${keyword.keyword}'),
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SearchResultScreen(
                      searchKey: keyword.keyword,
                    );
                  })),
                }
            },
            labelStyle: const TextStyle(
                color: PZColors.pzBlack, fontSize: Sizes.bodyFontSize),
            deleteIcon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: widget.editMode == EditMode.edit
                    ? const Icon(
                        Icons.cancel,
                        size: Sizes.regularIconSize,
                        color: PZColors.pzGrey,
                      )
                    : null),
            onDeleted: widget.editMode == EditMode.edit
                ? () {
                    debugPrint(
                        'Removing keyword: ${keyword.keyword} ~ ${keyword.id}');
                    ref.read(keywordsProvider).removeKeywordLocally(keyword);
                    // showSnackbarWithMessage(context, 'Keyword removed');
                  }
                : null,
          );
        },
      ).toList(),
    );
  }
}

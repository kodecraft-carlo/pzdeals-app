import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_result.dart';

class FilterByCollectionWidget extends ConsumerStatefulWidget {
  const FilterByCollectionWidget({super.key});

  @override
  _FilterByCollectionWidgetState createState() =>
      _FilterByCollectionWidgetState();
}

class _FilterByCollectionWidgetState
    extends ConsumerState<FilterByCollectionWidget> {
  @override
  Widget build(BuildContext context) {
    final searchFilterState = ref.watch(searchFilterProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Wrap(
          spacing: 5.0,
          children:
              searchFilterState.collections.map((CollectionData collection) {
            return FilterChip(
              label: Text(
                collection.title,
                style: TextStyle(
                    color:
                        searchFilterState.isCollectionIdExisting(collection.id)
                            ? PZColors.pzWhite
                            : PZColors.pzBlack,
                    fontSize: Sizes.fontSizeSmall),
              ),
              checkmarkColor: PZColors.pzWhite,
              selectedColor: PZColors.pzGreen,
              backgroundColor: PZColors.pzLightGrey,
              selected: searchFilterState.isCollectionIdExisting(collection.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
                side: const BorderSide(color: Colors.transparent, width: 0),
              ),
              onSelected: (bool selected) {
                searchFilterState.toggleCollectionMap(
                    collection.id, collection.title);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_result.dart';
import 'package:pzdeals/src/features/deals/state/provider_search.dart';

class FilterActionButtonsWidget extends ConsumerStatefulWidget {
  const FilterActionButtonsWidget({super.key});

  @override
  FilterActionButtonsWidgetState createState() =>
      FilterActionButtonsWidgetState();
}

class FilterActionButtonsWidgetState
    extends ConsumerState<FilterActionButtonsWidget> {
  @override
  Widget build(BuildContext context) {
    final searchFilterState = ref.watch(searchFilterProvider);
    final searchState = ref.watch(searchproductProvider);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes
                        .buttonBorderRadius), // Adjust the radius as needed
                  ),
                  backgroundColor: PZColors.pzOrange,
                  elevation: Sizes.buttonElevation),
              onPressed: searchFilterState.hasAnyFilterSelected
                  ? () {
                      searchFilterState.applyFilter();
                      searchState.setFilters(searchFilterState.filters);
                      searchState.loadProducts();
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text(
                'Apply Filter',
                style: TextStyle(color: PZColors.pzWhite),
              ),
            ))
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: TextButton(
              onPressed: () {
                searchFilterState.resetFilter();
                searchState.setFilters(searchFilterState.filters);
                searchState.loadProducts();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Reset',
                style: TextStyle(
                    color: PZColors.pzBlack, fontWeight: FontWeight.w600),
              )),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/filter_actionbuttons.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/filter_collection.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/filter_price.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/filter_store.dart';

Widget buildSheet(context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Search Filter',
                  style: TextStyle(
                      fontSize: Sizes.fontSizeLarge,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
                GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: Sizes.largeIconSize,
                    ))
              ],
            ),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Sizes.spaceBetweenSections,
                    ),
                    Text(
                      'By Store',
                      style: TextStyle(
                          fontSize: Sizes.fontSizeMedium,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),
                    FilterByStoresWidget(),
                    SizedBox(
                      height: Sizes.spaceBetweenSections,
                    ),
                    Text(
                      'By Price Range (\$)',
                      style: TextStyle(
                          fontSize: Sizes.fontSizeMedium,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: Sizes.spaceBetweenContentSmall,
                    ),
                    FilterByPriceWidget(),
                    SizedBox(
                      height: Sizes.spaceBetweenSectionsXL,
                    ),
                    Text(
                      'By Collection',
                      style: TextStyle(
                          fontSize: Sizes.fontSizeMedium,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),
                    FilterByCollectionWidget(),
                    SizedBox(
                      height: Sizes.spaceBetweenSectionsXL,
                    ),
                    FilterActionButtonsWidget()
                  ],
                ),
              ),
            )
          ]),
    );

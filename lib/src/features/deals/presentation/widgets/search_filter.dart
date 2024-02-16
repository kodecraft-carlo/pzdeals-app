import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .85,
        decoration: const BoxDecoration(
          color: PZColors.pzWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Sizes.dialogBorderRadius),
            topRight: Radius.circular(Sizes.dialogBorderRadius),
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.only(
                left: Sizes.paddingLeft,
                right: Sizes.paddingRightSmall,
                top: Sizes.paddingTopSmall),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: Sizes.spaceBetweenSections,
                      ),
                      const Text(
                        'By Store',
                        style: TextStyle(
                            fontSize: Sizes.fontSizeMedium,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.start,
                      ),
                      const StoresGrid(),
                      const SizedBox(
                        height: Sizes.spaceBetweenSections,
                      ),
                      const Text(
                        'By Price Range (\$)',
                        style: TextStyle(
                            fontSize: Sizes.fontSizeMedium,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: Sizes.spaceBetweenContentSmall,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Min',
                                fillColor: PZColors.pzGrey.withOpacity(0.125),
                                filled: true,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Sizes.textFieldCornerRadius),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets.all(Sizes.paddingAllSmall),
                              ),
                              style: const TextStyle(
                                  fontSize: Sizes.textFieldFontSize,
                                  color: PZColors.pzBlack),
                            ),
                          ),
                          const Icon(
                            Icons.horizontal_rule_sharp,
                            color: PZColors.pzBlack,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Max',
                                fillColor: PZColors.pzGrey.withOpacity(0.125),
                                filled: true,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      Sizes.textFieldCornerRadius),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets.all(Sizes.paddingAllSmall),
                              ),
                              style: const TextStyle(
                                  fontSize: Sizes.textFieldFontSize,
                                  color: PZColors.pzBlack),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Sizes.spaceBetweenContentSmall,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle button 1 press
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(Sizes
                                        .buttonBorderRadius), // Adjust the radius as needed
                                  ),
                                  backgroundColor: PZColors.pzLightGrey),
                              child: const Text(
                                '\$1 - 49',
                                style: TextStyle(color: PZColors.pzBlack),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: Sizes.paddingAllSmall,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle button 1 press
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(Sizes
                                        .buttonBorderRadius), // Adjust the radius as needed
                                  ),
                                  backgroundColor: PZColors.pzLightGrey),
                              child: const Text(
                                '\$50 - 99',
                                style: TextStyle(color: PZColors.pzBlack),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: Sizes.paddingAllSmall,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle button 1 press
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(Sizes
                                        .buttonBorderRadius), // Adjust the radius as needed
                                  ),
                                  backgroundColor: PZColors.pzLightGrey),
                              child: const Text(
                                '\$99 up',
                                style: TextStyle(color: PZColors.pzBlack),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Sizes.spaceBetweenSectionsXL,
                      ),
                      const Text(
                        'By Collection',
                        style: TextStyle(
                            fontSize: Sizes.fontSizeMedium,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.start,
                      ),
                      const FilterByCollectionWidget(),
                      const SizedBox(
                        height: Sizes.spaceBetweenSectionsXL,
                      ),
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
                                minimumSize: const Size(150, 40),
                                elevation: Sizes.buttonElevation),
                            onPressed: () {
                              // Handle button action
                              Navigator.of(context).pop();
                            },
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
                              // Handle button action
                              debugPrint('filter reset');
                            },
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                  color: PZColors.pzBlack,
                                  fontWeight: FontWeight.w600),
                            )),
                      )
                    ],
                  ),
                ),
              )
            ])),
      ),
    );
  }
}

class StoresGrid extends StatefulWidget {
  const StoresGrid({super.key});

  @override
  _StoresGridState createState() => _StoresGridState();
}

class _StoresGridState extends State<StoresGrid> {
  bool isExpanded = false;

  final List<String> stores = [
    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Amazon_logo.svg/2560px-Amazon_logo.png',
    'https://upload.wikimedia.org/wikipedia/commons/4/48/EBay_logo.png',
    'https://i.insider.com/6437208ae955f50018faa831?width=750&format=jpeg&auto=webp',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Best_Buy_logo_2018.svg/1280px-Best_Buy_logo_2018.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Macys_logo.svg/1024px-Macys_logo.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Woot_Logo.svg/2560px-Woot_Logo.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Marshalls_Logo.svg/2560px-Marshalls_Logo.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Kohl%27s_logo.svg/2560px-Kohl%27s_logo.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Aeropostale_logo.svg/2560px-Aeropostale_logo.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Sam%27s_Club_Logo_2020.svg/2560px-Sam%27s_Club_Logo_2020.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 2,
          ),
          itemCount: stores.length > 6 && !isExpanded ? 6 : stores.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final store = stores[index];
            return Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Image.network(
                    store,
                    fit: BoxFit.fitWidth,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
        if (!isExpanded)
          TextButton(
            onPressed: () {
              setState(() {
                isExpanded = true;
              });
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Show more',
                  style: TextStyle(
                      color: PZColors.pzBlack, fontSize: Sizes.fontSizeSmall),
                ),
                Icon(Icons.expand_more, color: PZColors.pzBlack)
              ],
            ),
          ),
        if (isExpanded)
          TextButton(
            onPressed: () {
              setState(() {
                isExpanded = false;
              });
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Show less',
                  style: TextStyle(
                      color: PZColors.pzBlack, fontSize: Sizes.fontSizeSmall),
                ),
                Icon(Icons.expand_less, color: PZColors.pzBlack)
              ],
            ),
          ),
      ],
    );
  }
}

class FilterByCollectionWidget extends StatefulWidget {
  const FilterByCollectionWidget({super.key});

  @override
  State<FilterByCollectionWidget> createState() =>
      _FilterByCollectionWidgetState();
}

class _FilterByCollectionWidgetState extends State<FilterByCollectionWidget> {
  final List<String> collectionPills = [
    'Wireless Earbuds',
    'In-Ear Headphones',
    'Audio Speakers',
    'Powerbanks & Chargers',
    'Clothes & Shoes',
    'Kids & Toys',
    'Home & Kitchen',
  ];
  List<String> filters = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Wrap(
          spacing: 5.0,
          children: collectionPills.map((String collection) {
            return FilterChip(
              label: Text(
                collection,
                style: TextStyle(
                    color: filters.contains(collection)
                        ? PZColors.pzWhite
                        : PZColors.pzBlack,
                    fontSize: Sizes.fontSizeSmall),
              ),
              checkmarkColor: PZColors.pzWhite,
              selectedColor: PZColors.pzOrange,
              backgroundColor: PZColors.pzLightGrey,
              selected: filters.contains(collection),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
                  side: const BorderSide(color: Colors.transparent, width: 0)),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    filters.add(collection);
                  } else {
                    filters.remove(collection);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}

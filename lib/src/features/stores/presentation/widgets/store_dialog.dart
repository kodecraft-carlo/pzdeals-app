import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class StoreDialog extends StatelessWidget {
  const StoreDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        surfaceTintColor: PZColors.pzWhite,
        backgroundColor: PZColors.pzWhite,
        shadowColor: PZColors.pzBlack,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.dialogBorderRadius),
        ),
        child: const Padding(
          padding: EdgeInsets.only(bottom: Sizes.paddingBottomSmall),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Sizes.paddingAll),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StoreCollectionList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  dynamic expandedValue;
  String headerValue;
  bool isExpanded;
}

class StoreCollectionList extends StatefulWidget {
  const StoreCollectionList({super.key});

  @override
  State<StoreCollectionList> createState() => _StoreCollectionListState();
}

class _StoreCollectionListState extends State<StoreCollectionList> {
  late int _expandedIndex;
  final List<Item> _data = [
    Item(headerValue: "Coupons", expandedValue: ["Coupon 1", "Coupon 2"]),
    Item(headerValue: "Shop the full sale", expandedValue: [
      "Men",
      "Women",
      "Kids & Toys",
      "Shoes",
      "Jewelry",
      "Handbags",
      "Beauty",
      "Home"
    ]),
  ];

  @override
  void initState() {
    super.initState();
    _expandedIndex = -1; // Initially no item is expanded
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _expandedIndex = isExpanded ? -1 : index;
          });
        },
        elevation: 0,
        dividerColor: Colors.transparent,
        expandedHeaderPadding: EdgeInsets.zero,
        children: _data.asMap().entries.map<ExpansionPanel>((entry) {
          final int index = entry.key;
          final Item item = entry.value;
          return ExpansionPanel(
            backgroundColor: PZColors.pzWhite,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedIndex = isExpanded ? -1 : index;
                  });
                },
                child: ListTile(
                  title: Text(item.headerValue,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  dense: true,
                  focusColor: PZColors.pzOrange,
                ),
              );
            },
            body: ListView.builder(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: item.expandedValue.length,
                itemBuilder: (BuildContext context, int index) {
                  final collection = item.expandedValue[index];
                  return TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: Sizes.fontSizeMedium,
                          fontWeight: FontWeight.normal,
                          color: PZColors.pzBlack),
                      backgroundColor: PZColors.pzLightGrey,
                      foregroundColor: PZColors.pzOrange,
                      surfaceTintColor: Colors.transparent,
                      alignment: Alignment.centerLeft,
                    ),
                    onPressed: () {
                      debugPrint("store collection deal tapped");
                    },
                    child: Text(collection),
                  );
                }),
            isExpanded: _expandedIndex == index,
          );
        }).toList(),
      ),
    );
  }
}

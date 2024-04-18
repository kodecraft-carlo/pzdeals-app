import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/actions/show_snackbar.dart';
import 'package:pzdeals/src/common_widgets/coupon_code_widget.dart';
import 'package:pzdeals/src/constants/index.dart';

class StoreDialog extends StatelessWidget {
  const StoreDialog({super.key, required this.htmlData});

  final String htmlData;
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: Sizes.paddingBottomSmall),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.paddingAll),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StoreCollectionList(
                    htmlData: htmlData,
                  ),
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

class Coupon {
  String code;
  String description;
  String url;

  Coupon({required this.code, required this.description, required this.url});
}

class StoreCollectionList extends StatefulWidget {
  const StoreCollectionList({super.key, required this.htmlData});

  final String htmlData;
  @override
  State<StoreCollectionList> createState() => _StoreCollectionListState();
}

class _StoreCollectionListState extends State<StoreCollectionList> {
  late int _expandedIndex;
  List<Item> _data = [];
  List<Coupon> _coupons = [];

  @override
  void initState() {
    super.initState();
    _data = extractDataFromHtml(widget.htmlData);
    _coupons = extractCouponsFromHtml(widget.htmlData);
    if (_coupons.isNotEmpty) {
      debugPrint('coupon code::: ${_coupons[0].code}');
      _data.insert(
          0,
          Item(
            headerValue: 'Coupons',
            expandedValue: _coupons,
          ));
    }
    _expandedIndex = -1; // Initially no item is expanded
  }

  @override
  Widget build(BuildContext context) {
    return _data.isEmpty && _coupons.isEmpty
        ? const Text("No deals from this store yet. Stay tuned!")
        : SingleChildScrollView(
            child: Column(
              children: [
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _expandedIndex = isExpanded ? index : -1;
                    });
                  },
                  elevation: 0,
                  dividerColor: Colors.black.withOpacity(.1),
                  expandedHeaderPadding: EdgeInsets.zero,
                  children: _data.asMap().entries.map<ExpansionPanel>((entry) {
                    final int index = entry.key;
                    final Item item = entry.value;
                    return item.headerValue == 'Coupons'
                        ? ExpansionPanel(
                            canTapOnHeader: true,
                            backgroundColor: PZColors.pzWhite,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTile(
                                title: Text(item.headerValue,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                dense: false,
                                focusColor: PZColors.pzOrange,
                                contentPadding: EdgeInsets.zero,
                                splashColor: Colors.transparent,
                                enableFeedback: false,
                                onTap: () {
                                  setState(() {
                                    _expandedIndex = isExpanded ? -1 : index;
                                  });
                                },
                              );
                            },
                            body: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: item.expandedValue.length,
                              itemBuilder: (BuildContext context, int index) {
                                final coupon = item.expandedValue[index];

                                List<String> parts =
                                    coupon.description.split(coupon.code);
                                return GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: coupon.code));
                                    showSnackbarWithMessage(
                                        context, 'Coupon code copied');
                                    if (coupon.url != null &&
                                        coupon.url != '') {
                                      openBrowser(coupon.url!);
                                    }
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: PZColors.pzLightGrey,
                                    ),
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: parts[0],
                                          style: const TextStyle(
                                            color: PZColors.pzBlack,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.middle,
                                            child: CouponCodeWidget(
                                              buildcontext: context,
                                              text: coupon.code,
                                              url: coupon.url,
                                            )),
                                        TextSpan(
                                          text: parts[1],
                                          style: const TextStyle(
                                              color: PZColors.pzBlack,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ]),
                                    ),
                                  ),
                                );
                                ;
                              },
                            ),
                            isExpanded: _expandedIndex == index,
                          )
                        : ExpansionPanel(
                            canTapOnHeader: true,
                            backgroundColor: PZColors.pzWhite,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTile(
                                title: Text(item.headerValue,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                dense: false,
                                focusColor: PZColors.pzOrange,
                                contentPadding: EdgeInsets.zero,
                                splashColor: Colors.transparent,
                                enableFeedback: false,
                                onTap: item.expandedValue.length > 0
                                    ? () {
                                        setState(() {
                                          _expandedIndex =
                                              isExpanded ? -1 : index;
                                        });
                                      }
                                    : null,
                              );
                            },
                            body: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: item.expandedValue.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final collection = item.expandedValue[index];
                                  return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: GestureDetector(
                                        onTap: () {
                                          openBrowser(collection['link'] ?? '');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: PZColors.pzLightGrey,
                                          ),
                                          child: Text(
                                            collection['list_name'] ?? '',
                                            style: const TextStyle(
                                                color: PZColors.pzOrange,
                                                fontSize: Sizes.fontSizeSmall),
                                          ),
                                        ),
                                      ));
                                }),
                            isExpanded: _expandedIndex == index,
                          );
                  }).toList(),
                )
              ],
            ),
          );
  }
}

List<Item> extractDataFromHtml(String htmlString) {
  List<Item> result = [];

  // Parse the HTML string
  htmlDom.Document document = htmlParser.parse(htmlString);

  // Find all <ul> elements
  List<htmlDom.Element> ulElements = document.querySelectorAll('ul');

  String noHeaderList = '';
  // Iterate over each <ul> element
  for (htmlDom.Element ulElement in ulElements) {
    // Find all <li> elements within the <ul> element
    List<htmlDom.Element> liElements = ulElement.querySelectorAll('li');

    List<Map<String, dynamic>> listItems = [];

    // Iterate over each <li> element
    for (htmlDom.Element liElement in liElements) {
      // Check if the <li> element contains an anchor tag
      htmlDom.Element? anchorElement = liElement.querySelector('a');
      if (anchorElement != null) {
        // If an anchor tag is present, treat it as a regular list item
        String listItemText = anchorElement.text.trim();
        String link = anchorElement.attributes['href'] ?? '';
        listItems.add({'list_name': listItemText, 'link': link});
      } else {
        noHeaderList = liElement.text.trim();
        // If no anchor tag is present, treat it as a header
        // String headerText = liElement.text.trim();
        // result.add(Item(headerValue: headerText, expandedValue: []));
      }
    }

    // If there are regular list items, add them to the result
    if (listItems.isNotEmpty) {
      // Find the preceding <h3> element (if any) to use as the header
      htmlDom.Element? headerElement = ulElement.previousElementSibling;
      if (headerElement != null && headerElement.localName == 'h3') {
        String headerText = headerElement.text.trim();
        if (!headerText.toLowerCase().contains('coupon')) {
          result.add(Item(
            headerValue: headerText,
            expandedValue: listItems,
          ));
        }
      } else if (headerElement != null &&
          headerElement.localName == 'p' &&
          headerElement.text.trim() != '') {
        String headerText = headerElement.text.trim();
        result.add(Item(
          headerValue: headerText,
          expandedValue: listItems,
        ));
      } else {
        result.add(Item(
          headerValue: noHeaderList,
          expandedValue: listItems,
        ));
      }
    }
  }

  return mergeItems(result);
}

List<Item> mergeItems(List<Item> items) {
  Map<String, List<dynamic>> mergedValues = {};

  // Iterate through items and merge expandedValue based on headerValue
  for (Item item in items) {
    String headerValue = item.headerValue;
    if (!mergedValues.containsKey(headerValue)) {
      // Initialize list for headerValue if not present
      mergedValues[headerValue] = [];
    }
    // Add the expandedValue to the list for the corresponding headerValue
    mergedValues[headerValue]?.addAll(item.expandedValue);
  }

  // Create a new list of merged items
  List<Item> mergedItems = [];

  // Iterate through mergedValues and create new items
  mergedValues.forEach((headerValue, expandedValue) {
    if (headerValue != '' && mergedValues.length > 1) {
      mergedItems.add(Item(
        headerValue: headerValue,
        expandedValue: expandedValue,
      ));
    } else if (mergedValues.length == 1) {
      mergedItems.add(Item(
        headerValue: headerValue == '' ? 'Store Sale' : headerValue,
        expandedValue: expandedValue,
      ));
    }
  });

  return mergedItems;
}

List<Coupon> extractCouponsFromHtml(String htmlString) {
  List<Coupon> coupons = [];

  // Parse the HTML string
  htmlDom.Document document = htmlParser.parse(htmlString);

  // Find all <ul> elements
  List<htmlDom.Element> ulElements = document.querySelectorAll('ul');

  // Iterate over each <ul> element
  for (htmlDom.Element ulElement in ulElements) {
    // Find all <li> elements within the <ul> element
    List<htmlDom.Element> liElements = ulElement.querySelectorAll('li');

    // Iterate over each <li> element
    for (htmlDom.Element liElement in liElements) {
      // Check if the <li> element contains the word "Coupon"
      if (liElement.text.toLowerCase().contains('coupon')) {
        // Extract the coupon code

        // Extract the coupon description
        String couponDescription = liElement.text.trim();
        String couponCode = _extractCouponCode(couponDescription);
        String couponUrl = '';

        htmlDom.Element? anchorElement = liElement.querySelector('a');
        if (anchorElement != null) {
          // If an anchor tag is present, treat it as a regular list item
          String link = anchorElement.attributes['href'] ?? '';
          couponUrl = link;
        }
        // Create a Coupon object and add it to the list
        coupons.add(Coupon(
            code: couponCode, description: couponDescription, url: couponUrl));
      }
    }
  }

  return coupons;
}

String _extractCouponCode(String text) {
  List<RegExp> regexPatterns = [
    RegExp(r'(?<=\b[cC]oupon\s[cC]ode[:]?[-]?[:]?[\s-]?)(\b\w+\b)',
        caseSensitive: false),
    RegExp(r'(?<=\b[cC]ode[:]?[-]?[:]?[\s-])(\b\w+\b)', caseSensitive: false),
    RegExp(
      r'(?<=\b[cC]oupon\s[cC]ode\s*[-:]*\s*)\b\w+\b',
      caseSensitive: false,
    ),
    RegExp(
      r'(?<=\b[cC]oupon\s[cC]ode\s*)\b\w+\b',
      caseSensitive: false,
    ),
    RegExp(
      r'\b[Cc]oupon\s+([a-zA-Z0-9]+)\b',
      caseSensitive: false,
    )
  ];

  for (RegExp pattern in regexPatterns) {
    Match? match = pattern.firstMatch(text);
    if (match != null) {
      try {
        if ((match.group(1) != null || match.group(1)!.isNotEmpty)) {
          return match.group(1) ?? '';
        }
      } catch (e) {
        return match.group(0) ?? '';
      }
    }
  }
  return '';
}

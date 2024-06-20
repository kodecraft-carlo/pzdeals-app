import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/bouncing_arrow_down.dart';
import 'package:pzdeals/src/common_widgets/screen_collections_display.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/for_you_collection_deal_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ForYouCollectionList extends StatefulWidget {
  const ForYouCollectionList(
      {super.key,
      required this.title,
      required this.productData,
      required this.collectionId});

  final String title;
  final int collectionId;
  final List<ProductDealcardData> productData;

  @override
  ForYouCollectionListState createState() => ForYouCollectionListState();
}

class ForYouCollectionListState extends State<ForYouCollectionList> {
  bool showMore = false;
  bool _isScrollingRight = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          showMore = scrollController.position.maxScrollExtent > 0;
        });
      }
    });
  }

  void _onScroll() {
    bool newIsScrollingRight = scrollController.position.userScrollDirection ==
            ScrollDirection.reverse ||
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent;

    if (newIsScrollingRight != _isScrollingRight) {
      setState(() {
        _isScrollingRight = newIsScrollingRight;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 2.8;

    String sectionTitle = '';
    if (widget.title == 'Toys Deals') {
      sectionTitle = 'Toy Deals';
    } else if (widget.title == 'Clothing Deals') {
      sectionTitle = 'Clothing & Accessory Deals';
    } else {
      sectionTitle = widget.title;
    }
    return Container(
      key: ValueKey('foryoucollection_${widget.collectionId}'),
      height: 313,
      margin: const EdgeInsets.only(
        bottom: Sizes.marginBottom,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                  text: sectionTitle,
                  textDisplayType: TextDisplayType.sectionTitle),
              Flexible(
                child: ListView.separated(
                  addAutomaticKeepAlives: false,
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget.productData.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < widget.productData.length) {
                      final product = widget.productData[index];
                      return SizedBox(
                        width: itemWidth,
                        child: AspectRatio(
                            aspectRatio: 2 / 3.5,
                            child: StaticProductDealCardWidget(
                              productData: product,
                            )),
                      );
                    } else {
                      return NavigateScreenWidget(
                        destinationWidget: CollectionDisplayScreenWidget(
                          collectionTitle: widget.title,
                          collectionId: widget.collectionId,
                        ),
                        childWidget: Container(
                          width: itemWidth,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(Sizes.cardBorderRadius),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'View more',
                                style: TextStyle(
                                  color: PZColors.pzOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_circle_right_outlined,
                                  color: PZColors.pzOrange),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: Sizes.spaceBetweenContent),
                ),
              ),
            ],
          ),
          showMore && !_isScrollingRight
              ? Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      if (scrollController.position.pixels +
                              (MediaQuery.of(context).size.width / 1.5) >
                          scrollController.position.maxScrollExtent - 200) {
                        setState(() {
                          _isScrollingRight = true;
                        });
                      }
                      scrollController.animateTo(
                          scrollController.position.pixels +
                              MediaQuery.of(context).size.width / 1.5,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut);
                    },
                    child: const Skeleton.ignore(child: ListArrowIcon()),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class ListArrowIcon extends StatelessWidget {
  const ListArrowIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -MathConstants.pi / 2,
      child: BouncingArrowIcon(
        height: 20,
        icon: Stack(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: PZColors.pzOrange, // Background color
                shape: BoxShape.circle, // Circular shape
              ),
            ),
            const Positioned.fill(
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white, // Icon color
                  size: 20, // Icon size
                ),
              ),
            ),
          ],
        ),
        color: Colors.orange,
      ),
    );
  }
}

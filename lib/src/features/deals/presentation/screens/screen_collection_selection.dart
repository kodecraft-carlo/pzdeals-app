import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/common_widgets/category_image.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';

class CollectionSelectionWidget extends StatefulWidget {
  const CollectionSelectionWidget({super.key});

  @override
  _CollectionSelectionWidgetState createState() =>
      _CollectionSelectionWidgetState();
}

class _CollectionSelectionWidgetState extends State<CollectionSelectionWidget> {
  Set<String> selectedCategories = Set<String>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PZColors.pzWhite,
          automaticallyImplyLeading: false,
          title: const Text(
            'Select Collection to show on \'For You\'',
            style: TextStyle(
              color: PZColors.pzBlack,
              fontWeight: FontWeight.w600,
              fontSize: Sizes.fontSizeMedium,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              iconSize: Sizes.screenCloseIconSize,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          crossAxisCount: 3,
          children: <Widget>[
            GridItemWidget(
                containerChild: SizedBox.square(
                  child: Container(
                    color: PZColors.pzOrange,
                    child: const Icon(
                      Icons.flash_on_rounded,
                      color: PZColors.pzWhite,
                      size: 70,
                    ),
                  ),
                ),
                categoryLabel: 'Flash Deals',
                isSelected: selectedCategories.contains('Flash Deals'),
                onTap: () {
                  toggleCategorySelection('Flash Deals');
                }),
            GridItemWidget(
                containerChild: const CategoryImageWidget(
                  imageAsset:
                      'https://m.media-amazon.com/images/I/81Xi2PJMuGS.__AC_SX300_SY300_QL70_FMwebp_.jpg',
                  sourceType: 'network',
                ),
                categoryLabel: 'Home',
                isSelected: selectedCategories.contains('Home'),
                onTap: () {
                  toggleCategorySelection('Home');
                }),
            GridItemWidget(
                containerChild: const CategoryImageWidget(
                  imageAsset:
                      'https://m.media-amazon.com/images/I/71x5zjdEJrL._AC_UY218_.jpg',
                  sourceType: 'network',
                ),
                categoryLabel: 'Computers',
                isSelected: selectedCategories.contains('Computers'),
                onTap: () {
                  toggleCategorySelection('Computers');
                }),
            GridItemWidget(
                containerChild: const CategoryImageWidget(
                  imageAsset:
                      'https://m.media-amazon.com/images/I/91FnWK7rDLL._AC_UL320_.jpg',
                  sourceType: 'network',
                ),
                categoryLabel: 'Clothing',
                isSelected: selectedCategories.contains('Clothing'),
                onTap: () {
                  toggleCategorySelection('Clothing');
                }),
            GridItemWidget(
                containerChild: const CategoryImageWidget(
                  imageAsset:
                      'https://m.media-amazon.com/images/I/71qONUlf+ZL._AC_UL320_.jpg',
                  sourceType: 'network',
                ),
                categoryLabel: 'Toys',
                isSelected: selectedCategories.contains('Toys'),
                onTap: () {
                  toggleCategorySelection('Toys');
                }),
            GridItemWidget(
                containerChild: const CategoryImageWidget(
                  imageAsset:
                      'https://5.imimg.com/data5/AU/DW/KG/SELLER-91627945/grocery-plain-paper-pouch.jpg',
                  sourceType: 'network',
                ),
                categoryLabel: 'Grocery',
                isSelected: selectedCategories.contains('Grocery'),
                onTap: () {
                  toggleCategorySelection('Grocery');
                }),
            GridItemWidget(
                containerChild: const CategoryImageWidget(
                  imageAsset:
                      'https://m.media-amazon.com/images/I/71M6pSJZoLL._AC_UL320_.jpg',
                  sourceType: 'network',
                ),
                categoryLabel: 'Kitchen',
                isSelected: selectedCategories.contains('Kitchen'),
                onTap: () {
                  toggleCategorySelection('Kitchen');
                }),
            GridItemWidget(
                containerChild: const CategoryImageWidget(
                  imageAsset:
                      'https://m.media-amazon.com/images/I/71URMW1xaBL._AC_UL320_.jpg',
                  sourceType: 'network',
                ),
                categoryLabel: 'Shoes',
                isSelected: selectedCategories.contains('Shoes'),
                onTap: () {
                  toggleCategorySelection('Shoes');
                }),
            GridItemWidget(
                containerChild: const CategoryImageWidget(
                  imageAsset:
                      'https://m.media-amazon.com/images/I/71FuI8YvCNL._AC_SX522_.jpg',
                  sourceType: 'network',
                ),
                categoryLabel: 'Mobile',
                isSelected: selectedCategories.contains('Mobile'),
                onTap: () {
                  toggleCategorySelection('Mobile');
                }),
          ],
        ),
        bottomNavigationBar: const BottomSheetWidget(),
      ),
    );
  }

  void toggleCategorySelection(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }
}

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(Sizes.paddingAll),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Sizes.buttonBorderRadius),
                  ),
                  backgroundColor: PZColors.pzOrange,
                  minimumSize: const Size(150, 40),
                  elevation: Sizes.buttonElevation),
              onPressed: () {
                Navigator.of(context).pop();
                // Handle button action
                debugPrint('Apply Selection pressed');
              },
              child: const Text(
                'Apply Selection',
                style: TextStyle(color: PZColors.pzWhite),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridItemWidget extends StatefulWidget {
  const GridItemWidget({
    super.key,
    required this.containerChild,
    required this.categoryLabel,
    required this.isSelected,
    required this.onTap,
  });

  final Widget containerChild;
  final String categoryLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  _GridItemWidgetState createState() => _GridItemWidgetState();
}

class _GridItemWidgetState extends State<GridItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _handleScaleAnimation();
      },
      child: IntrinsicHeight(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensure the column takes minimum height
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Sizes.containerBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    widget.containerChild,
                    if (widget.isSelected)
                      SizedBox.square(
                        dimension: 80,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            color: PZColors.pzGreen.withOpacity(0.3),
                          ),
                        ),
                      ),
                    if (widget.isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: PZColors.pzWhite,
                        size: 40.0,
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: Sizes.spaceBetweenContent,
              ),
              Text(
                widget.categoryLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected ? Colors.black : PZColors.pzBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleScaleAnimation() {
    if (widget.isSelected) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }
}

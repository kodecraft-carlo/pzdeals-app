import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/common_widgets/sliver_appbar.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/more/models/index.dart';
import 'package:pzdeals/src/features/more/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/more/presentation/widgets/shop_category.dart';

class MoreScreen extends StatelessWidget {
  MoreScreen({super.key});

  final List<CategoryData> category = [
    CategoryData(
        category: 'Home & Living',
        categoryAssetImage:
            'https://m.media-amazon.com/images/I/71MXVX1pT3L._AC_UL480_FMwebp_QL65_.jpg',
        assetSourceType: 'network'),
    CategoryData(
        category: 'Computers',
        categoryAssetImage:
            'https://m.media-amazon.com/images/I/71cvBlbsQwL._AC_UL480_FMwebp_QL65_.jpg',
        assetSourceType: 'network'),
    CategoryData(
        category: 'Clothing',
        categoryAssetImage:
            'https://m.media-amazon.com/images/I/71wwycm23mL._AC_UL480_FMwebp_QL65_.jpg',
        assetSourceType: 'network'),
    CategoryData(
        category: 'Kids & Toys',
        categoryAssetImage:
            'https://m.media-amazon.com/images/I/71loy0S3FQL._AC_UL480_FMwebp_QL65_.jpg',
        assetSourceType: 'network'),
    CategoryData(
        category: 'Grocery',
        categoryAssetImage:
            'https://food-ubc.b-cdn.net/wp-content/uploads/2020/02/Save-Money-On-Groceries_UBC-Food-Services.jpg',
        assetSourceType: 'network'),
    CategoryData(
        category: 'Kitchen',
        categoryAssetImage:
            'https://m.media-amazon.com/images/I/819zf0AMM2L._AC_UL480_QL65_.jpg',
        assetSourceType: 'network'),
    CategoryData(
        category: 'Shoes',
        categoryAssetImage:
            'https://m.media-amazon.com/images/I/71WIQ8YMNsS._AC_UL480_FMwebp_QL65_.jpg',
        assetSourceType: 'network'),
    CategoryData(
        category: 'Mobile',
        categoryAssetImage:
            'https://www.istore.co.za/media/catalog/product/i/p/iphone_14_pro_deep_purple-6.jpg?optimize=medium&bg-color=255,255,255&fit=bounds&height=700&width=700&canvas=700:700',
        assetSourceType: 'network'),
    CategoryData(
        category: 'Electronics',
        categoryAssetImage:
            'https://m.media-amazon.com/images/I/71347dxhUIL._AC_UY327_QL65_.jpg',
        assetSourceType: 'network'),
    CategoryData(
        category: 'Sports',
        categoryAssetImage:
            'https://m.media-amazon.com/images/I/91vdgs5FY4L._AC_UL480_FMwebp_QL65_.jpg',
        assetSourceType: 'network'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBarWidget(
              innerBoxIsScrolled: innerBoxIsScrolled,
              searchFieldWidget: const MoreScreenSearchFieldWidget(
                hintText: "Search deals",
              )),
        ];
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MoreShortcutsWidget(),
          const SizedBox(height: Sizes.spaceBetweenContentSmall),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.paddingAll),
              child: Text("Shop by Category",
                  style: TextStyle(
                      color: PZColors.pzBlack,
                      fontSize: Sizes.sectionHeaderFontSize,
                      fontWeight: FontWeight.w600))),
          Expanded(
            child: ShopCategory(categoryData: category),
          )
        ],
      ),
    ));
  }
}

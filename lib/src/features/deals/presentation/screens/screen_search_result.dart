import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/slide_up_dialog.dart';
import 'package:pzdeals/src/common_widgets/search_field.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_search_deals.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({
    super.key,
    this.searchKey = '',
  });

  final String searchKey;

  @override
  Widget build(BuildContext context) {
    final String? textFieldValue =
        ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: PZColors.pzWhite,
        surfaceTintColor: PZColors.pzWhite,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchDealScreen())),
              child: const Icon(Icons.arrow_back_ios_new),
            ),
            const SizedBox(width: Sizes.spaceBetweenContent),
            Expanded(
              child: SearchFieldWidget(
                hintText: "Search deals",
                textValue: textFieldValue ?? searchKey,
                autoFocus: false,
                destinationScreen: const SearchResultScreen(),
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: Sizes.paddingRight),
              child: SlideUpDialog(
                  childWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.filter_alt_outlined, color: PZColors.pzOrange),
                      Text(
                        "Filter",
                        style: TextStyle(
                            color: PZColors.pzOrange,
                            fontSize: Sizes.fontSizeXSmall,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  slideUpDialog: SearchFilter()))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: Sizes.paddingLeft,
          right: Sizes.paddingRight,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text.rich(
            TextSpan(
              text: "Search result for '",
              style: const TextStyle(
                fontSize: Sizes.bodyFontSize,
                fontWeight: FontWeight.w500,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: textFieldValue ?? searchKey,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                ),
                const TextSpan(
                  text: "'",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceBetweenSections),
          Expanded(
            child: buildGridView(),
          ),
        ]),
      ),
    );
  }

  Widget buildGridView() {
    final List<ProductDealcardData> productData = [
      ProductDealcardData(
        productName: "Apple airpods pro 2nd generation usb-c",
        price: "199.99",
        storeAssetImage: "assets/images/store.png",
        oldPrice: "399.99",
        imageAsset: "assets/images/product.png",
        discountPercentage: 50,
        assetSourceType: 'asset',
      ),
      ProductDealcardData(
        productName: "Laptop 15.6 inch 8GB RAM 512GB SSD",
        price: "199.99",
        storeAssetImage: "assets/images/store.png",
        oldPrice: "399.99",
        imageAsset:
            "https://images-na.ssl-images-amazon.com/images/I/71qKfFqgEiL.jpg",
        discountPercentage: 50,
        assetSourceType: 'network',
      ),
      ProductDealcardData(
        productName: "Nike Dunk High Retro Shoes",
        price: "199.99",
        storeAssetImage: "assets/images/store.png",
        oldPrice: "399.99",
        imageAsset:
            "https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/cec5acec-f53e-40a1-80b5-a21ddb4267dc/dunk-high-retro-shoes-Cg1ncq.png",
        discountPercentage: 50,
        assetSourceType: 'network',
      ),
      ProductDealcardData(
        productName: "Apple Watch Series 7 45mm",
        price: "199.99",
        storeAssetImage: "assets/images/store.png",
        oldPrice: "399.99",
        imageAsset:
            "https://files.refurbed.com/ii/apple-watch-series-7-edst-45mm-1643193412.jpg",
        discountPercentage: 50,
        assetSourceType: 'network',
      ),
      ProductDealcardData(
        productName: "Apple Watch Series 7 45mm",
        price: "199.99",
        storeAssetImage: "assets/images/store.png",
        oldPrice: "399.99",
        imageAsset:
            "https://files.refurbed.com/ii/apple-watch-series-7-edst-45mm-1643193412.jpg",
        discountPercentage: 50,
        assetSourceType: 'network',
      ),
      ProductDealcardData(
        productName: "Apple Watch Series 7 45mm",
        price: "199.99",
        storeAssetImage: "assets/images/store.png",
        oldPrice: "399.99",
        imageAsset:
            "https://files.refurbed.com/ii/apple-watch-series-7-edst-45mm-1643193412.jpg",
        discountPercentage: 50,
        assetSourceType: 'network',
      )
    ];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 15, childAspectRatio: .62),
      itemCount: productData.length,
      itemBuilder: (BuildContext context, int index) {
        final product = productData[index];
        return ProductDealcard(
          productName: product.productName,
          price: product.price,
          storeAssetImage: product.storeAssetImage,
          oldPrice: product.oldPrice,
          imageAsset: product.imageAsset,
          discountPercentage: product.discountPercentage,
          assetSourceType: product.assetSourceType,
        );
      },
    );
  }
}

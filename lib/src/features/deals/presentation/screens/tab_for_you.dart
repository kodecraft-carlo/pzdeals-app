import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';

class ForYouWidget extends StatelessWidget {
  const ForYouWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProductDealcardData> productDeals = [
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
      )
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ForYouBannerWidget(),
          Padding(
              padding: const EdgeInsets.all(Sizes.paddingAll),
              child: Column(
                children: [
                  ForYouCollectionList(
                    title: 'Home Deals',
                    productData: productDeals,
                  ),
                  ForYouCollectionList(
                    title: 'Tech Deals',
                    productData: productDeals,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

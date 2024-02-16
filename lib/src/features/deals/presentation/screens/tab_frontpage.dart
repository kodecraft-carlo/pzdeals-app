import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/products_dispay.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/state/layout_type_provider.dart';

class FrontPageDealsWidget extends StatelessWidget {
  FrontPageDealsWidget({super.key});
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
          "https://cdn.shopify.com/s/files/1/1504/4320/products/0_0de7a40e-fd1c-4de6-87f9-a3880b763ac2.jpg?v=1549856539",
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final layoutType = ref.watch(layoutTypeProvider);
        return ProductsDisplay(
          productData: productData,
          layoutType: layoutType,
        );
      },
    );
  }
}

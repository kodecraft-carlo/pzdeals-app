import 'package:flutter/material.dart';
import 'package:pzdeals/src/common_widgets/product_image.dart';

class ProductImageDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const ProductImageDetailScreen(
      {super.key, required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        primary: true,
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: ProductImageWidget(
              imageAsset: imageUrl,
              sourceType: 'network',
              size: 'fullscreen',
              fit: BoxFit.contain),
        ),
      ),
    ));
  }
}

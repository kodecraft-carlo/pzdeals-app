import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class StoreImageWidget extends StatelessWidget {
  const StoreImageWidget({
    super.key,
    required this.storeAssetImage,
  });

  final String storeAssetImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Adjust the width as needed
      height: 10,
      child: Image.asset(
        storeAssetImage,
        fit: BoxFit.fitHeight,
        height: 10.0,
        // Set the height of the image box
      ),
    );
  }
}

import 'package:hive/hive.dart';

part 'product_data.g.dart';

@HiveType(typeId: 0)
class ProductDealcardData {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final dynamic price;

  @HiveField(3)
  final String storeAssetImage;

  @HiveField(4)
  final dynamic oldPrice;

  @HiveField(5)
  final String imageAsset;

  @HiveField(6)
  final dynamic discountPercentage;

  @HiveField(7)
  final String assetSourceType;

  @HiveField(8)
  final bool? isProductNoPrice;

  @HiveField(9)
  final bool? isProductExpired;

  @HiveField(10)
  final String? productDealDescription;

  @HiveField(11)
  final String? barcodeLink;

  @HiveField(12)
  final String? tagDealDescription;

  ProductDealcardData(
      {required this.productId,
      required this.productName,
      required this.price,
      required this.storeAssetImage,
      required this.oldPrice,
      required this.imageAsset,
      required this.discountPercentage,
      required this.assetSourceType,
      this.isProductNoPrice = false,
      this.isProductExpired = false,
      this.productDealDescription = '',
      required this.barcodeLink,
      this.tagDealDescription = ''});
}

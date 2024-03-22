import 'package:hive/hive.dart';

part 'store_data.g.dart';

@HiveType(typeId: 4)
class StoreData {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String storeName;

  @HiveField(2)
  final String storeAssetImage;

  @HiveField(3)
  final String assetSourceType;

  @HiveField(4)
  final String handle;

  @HiveField(5)
  final String? storeBody;

  @HiveField(6)
  final String? tagName;

  StoreData(
      {required this.storeName,
      required this.storeAssetImage,
      required this.assetSourceType,
      required this.id,
      required this.handle,
      this.storeBody,
      this.tagName});
}

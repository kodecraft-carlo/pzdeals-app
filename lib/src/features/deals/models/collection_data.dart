import 'package:hive/hive.dart';

part 'collection_data.g.dart';

@HiveType(typeId: 2)
class CollectionData {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String imageAsset;

  @HiveField(2)
  final String assetSourceType;

  @HiveField(3)
  final int id;

  @HiveField(4)
  final String? keyword;

  @HiveField(5)
  bool? isSubscribed;

  CollectionData({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.assetSourceType,
    this.keyword,
    this.isSubscribed = false,
  });

  set isSubscribedStatus(bool status) {
    isSubscribed = status;
  }
}

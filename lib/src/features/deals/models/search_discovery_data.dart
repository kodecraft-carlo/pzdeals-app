import 'package:hive/hive.dart';

part 'search_discovery_data.g.dart';

@HiveType(typeId: 9)
class SearchDiscoveryData {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String imageAsset;

  @HiveField(2)
  final String assetSourceType;

  SearchDiscoveryData({
    required this.title,
    required this.imageAsset,
    required this.assetSourceType,
  });
}

import 'package:hive/hive.dart';

part 'pzstore_data.g.dart';

@HiveType(typeId: 3)
class PZStoreData {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String tagName;

  @HiveField(4)
  final String? bodyHtml;

  PZStoreData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.tagName,
    this.bodyHtml,
  });
}

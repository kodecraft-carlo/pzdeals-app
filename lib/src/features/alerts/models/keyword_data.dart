import 'package:hive/hive.dart';

part 'keyword_data.g.dart';

@HiveType(typeId: 7)
class KeywordData {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String keyword;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String datecreated;

  KeywordData({
    required this.keyword,
    required this.id,
    this.imageUrl = '',
    this.datecreated = '',
  });
}

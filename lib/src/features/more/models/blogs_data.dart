import 'package:hive/hive.dart';

part 'blogs_data.g.dart';

@HiveType(typeId: 6)
class BlogData {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String blogTitle;

  @HiveField(2)
  final String blogImage;

  @HiveField(3)
  final String blogContent;

  BlogData({
    required this.id,
    required this.blogTitle,
    required this.blogImage,
    this.blogContent = '',
  });
}

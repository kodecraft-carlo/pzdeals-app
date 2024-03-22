import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/more/models/blogs_data.dart';

class BlogMapper {
  static List<BlogData> mapToBlogList(List<dynamic> responseData) {
    try {
      return List<BlogData>.from(responseData.map((json) {
        return BlogData(
          id: json['id'],
          blogTitle: json['title'],
          blogImage: json['image_src'],
        );
      }));
    } catch (e) {
      debugPrint('Error in mapToBlogList: $e');
      throw ('Error in mapToBlogList $e');
    }
  }

  static BlogData mapToBlogData(List<dynamic> responseData) {
    try {
      final json = responseData[0];

      return BlogData(
        id: json['id'],
        blogTitle: json['title'],
        blogImage: json['image_src'],
        blogContent: json['body_html'],
      );
    } catch (e) {
      debugPrint('Error in mapToBlogData: $e');
      throw ('Error in mapToBlogData $e');
    }
  }
}

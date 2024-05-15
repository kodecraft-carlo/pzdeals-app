import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pzdeals/src/features/more/models/blogs_data.dart';
import 'package:pzdeals/src/utils/data_mapper/blog_mapper.dart';
import 'package:pzdeals/src/utils/http/http_client.dart';
import 'package:pzdeals/src/utils/queries/index.dart';
import 'package:pzdeals/src/utils/queries/more_querybuilder.dart';

class BlogsService {
  Future<List<BlogData>> getCachedBlogs(String boxName) async {
    debugPrint("getCachedBlogs called for $boxName");
    final box = await Hive.openBox<BlogData>(boxName);
    final blogs = box.values.toList();
    await box.close();
    return blogs;
  }

  Future<List<BlogData>> fetchBlogs(
      String pageName, String boxName, int pageNumber) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchBlogs called for $pageName");

    try {
      Response response =
          await apiClient.dio.get(getBlogsByCollectionNameQuery(pageNumber)
              // options: Options(
              //   headers: {'Authorization': 'Bearer $accessToken'},
              // ),
              );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final blogs = BlogMapper.mapToBlogList(responseData);
        await _cacheBlogs(blogs, boxName);
        return blogs;
      } else {
        throw Exception(
            'Failed to fetch directus blog list ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus blog list');
    } catch (e, stackTrace) {
      debugPrint('Error fetching blogs: $stackTrace');
      throw Exception('Failed to fetch directus blog list');
    }
  }

  Future<void> _cacheBlogs(List<BlogData> blogs, String boxName) async {
    debugPrint("Caching blogs for $boxName");
    final box = await Hive.openBox<BlogData>(boxName);
    await box.clear(); // Clear existing cache
    for (final blog in blogs) {
      box.put(blog.id, blog);
    }
  }

  Future<BlogData> fetchBlogInfo(int blogId) async {
    ApiClient apiClient = ApiClient();
    // final authService = ref.watch(directusAuthServiceProvider);
    debugPrint("fetchBlogInfo Deals called for $blogId");

    try {
      Response response = await apiClient.dio.get(getBlogByIdQuery(blogId)
          // options: Options(
          //   headers: {'Authorization': 'Bearer $accessToken'},
          // ),
          );
      if (response.statusCode == 200) {
        final responseData = response.data["data"];
        if (responseData == null || responseData.isEmpty) {
          throw Exception('No Data Found');
        }

        final blog = BlogMapper.mapToBlogData(responseData);
        return blog;
      } else {
        throw Exception('Failed to fetch directus blog info');
      }
    } on DioException catch (e) {
      debugPrint("DioExceptionw: ${e.message}");
      throw Exception('Failed to fetch directus blog info');
    } catch (e, stackTrace) {
      debugPrint('Error fetching fetchBlogInfo blogs: $stackTrace');
      throw Exception('Failed to fetch directus blog info');
    }
  }
}

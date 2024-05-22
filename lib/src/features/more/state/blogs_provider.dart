import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/more/models/index.dart';
import 'package:pzdeals/src/features/more/services/blogs_service.dart';

class BlogsNotifier extends ChangeNotifier {
  final BlogsService _blogService = BlogsService();
  final String _collectionName = 'PzBlog';
  final String _boxName = 'pzblog';
  bool _isLoading = false;
  int pageNumber = 1;
  List<BlogData> _blogs = [];
  List<BlogData> _filteredBlogs = [];

  bool get isLoading => _isLoading;
  List<BlogData> get blogs => _blogs;
  List<BlogData> get filteredBlogs => _filteredBlogs;

  Future<void> refreshBlogs() async {
    _isLoading = true;
    notifyListeners();
    pageNumber = 1;
    try {
      final serverBlogs =
          await _blogService.fetchBlogs(_collectionName, _boxName, pageNumber);
      _blogs = serverBlogs;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading blogs: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBlogs() async {
    _isLoading = true;
    notifyListeners();
    pageNumber = 1;
    try {
      _blogs = await _blogService.getCachedBlogs(_boxName);
      notifyListeners();

      final serverBlogs =
          await _blogService.fetchBlogs(_collectionName, _boxName, pageNumber);
      _blogs = serverBlogs;
      notifyListeners();
    } catch (e) {
      debugPrint("error loading blogs: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreBlogs() async {
    pageNumber++;
    _isLoading = true;
    notifyListeners();

    try {
      final serverBlogs =
          await _blogService.fetchBlogs(_collectionName, _boxName, pageNumber);
      _blogs.addAll(serverBlogs);
      notifyListeners();
    } catch (e) {
      pageNumber--;
      debugPrint('error loading more blogs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterBlogs(String query) {
    _filteredBlogs = _blogs
        .where((blog) =>
            blog.blogTitle.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void clearFilter() {
    _filteredBlogs = _blogs;
    notifyListeners();
  }
}

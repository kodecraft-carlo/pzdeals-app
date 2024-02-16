class BlogData {
  final String blogTitle;
  final String blogImage;
  final String blogContent;

  BlogData({
    required this.blogTitle,
    required this.blogImage,
    this.blogContent = '',
  });
}

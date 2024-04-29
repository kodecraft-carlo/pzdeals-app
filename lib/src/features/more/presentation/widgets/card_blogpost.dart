import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/common_widgets/loading_dialog.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/more/models/index.dart';
import 'package:pzdeals/src/features/more/presentation/screens/screen_blogpost.dart';
import 'package:pzdeals/src/features/more/services/blogs_service.dart';

class BlogpostCardWidget extends StatefulWidget {
  const BlogpostCardWidget(
      {super.key,
      required this.blogTitle,
      required this.blogImage,
      required this.blogId});

  final String blogImage;
  final String blogTitle;
  final int blogId;
  BlogpostCardWidgetState createState() => BlogpostCardWidgetState();
}

class BlogpostCardWidgetState extends State<BlogpostCardWidget> {
  BlogsService blogService = BlogsService();

  Future<BlogData> fetchBlogData() async {
    return blogService.fetchBlogInfo(widget.blogId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        LoadingDialog.show(context);
        await fetchBlogData().then((value) {
          if (mounted) {
            LoadingDialog.hide(context);
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlogpostScreenWidget(
              blogData: value,
            );
          }));
        });
      },
      child: Card(
          surfaceTintColor: PZColors.pzLightGrey,
          elevation: 2,
          color: PZColors.pzWhite,
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.only(bottom: Sizes.marginBottom),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.cardBorderRadius),
            side: BorderSide(color: PZColors.pzGrey.withOpacity(.2), width: 1),
          ),
          child: SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: CachedNetworkImage(
                    imageUrl: widget.blogImage,
                    width: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 100),
                    errorWidget: (context, url, error) {
                      debugPrint('Error loading image: $error');
                      return Image.asset(
                        'assets/images/shortcuts/blogs_placeholder.png',
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Sizes.paddingAll,
                        horizontal: Sizes.paddingAllSmall),
                    child: Text(
                      widget.blogTitle,
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.fontSizeMedium),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/common_widgets/html_content.dart';
import 'package:pzdeals/src/common_widgets/scrollbar.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/more/models/index.dart';
import 'package:pzdeals/src/utils/storage/network_image_cache_manager.dart';

class BlogpostScreenWidget extends StatefulWidget {
  const BlogpostScreenWidget({super.key, required this.blogData});

  final BlogData blogData;
  BlogpostScreenWidgetState createState() => BlogpostScreenWidgetState();
}

class BlogpostScreenWidgetState extends State<BlogpostScreenWidget>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.blogData.blogTitle,
          style: const TextStyle(
            color: PZColors.pzBlack,
            fontWeight: FontWeight.w700,
            fontSize: Sizes.appBarFontSize,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        surfaceTintColor: PZColors.pzWhite,
        backgroundColor: PZColors.pzWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ScrollbarWidget(
        scrollController: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(Sizes.paddingAllSmall),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.blogData.blogImage != ""
                  ? CachedNetworkImage(
                      imageUrl: widget.blogData.blogImage,
                      cacheManager: networkImageCacheManager,
                      width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.fitWidth,
                      errorWidget: (context, url, error) => const SizedBox(),
                    )
                  : const SizedBox(),
              const SizedBox(height: Sizes.spaceBetweenContent),
              Text(
                widget.blogData.blogTitle,
                style: const TextStyle(
                    color: PZColors.pzBlack,
                    fontWeight: FontWeight.w700,
                    fontSize: Sizes.fontSizeLarge),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.spaceBetweenSections),
              HtmlContent(
                htmlContent: widget.blogData.blogContent,
                margin: Margins.symmetric(horizontal: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/more/models/index.dart';

class BlogpostScreenWidget extends StatelessWidget {
  const BlogpostScreenWidget({super.key, required this.blogData});

  final BlogData blogData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          blogData.blogTitle,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingAllSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            blogData.blogImage != ""
                ? CachedNetworkImage(
                    imageUrl: blogData.blogImage,
                    width: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.fitWidth,
                    errorWidget: (context, url, error) => const SizedBox(),
                  )
                : const SizedBox(),
            const SizedBox(height: Sizes.spaceBetweenContent),
            Text(
              blogData.blogTitle,
              style: const TextStyle(
                  color: PZColors.pzBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: Sizes.fontSizeLarge),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBetweenSections),
            Html(
              data: blogData.blogContent,
              shrinkWrap: true,
              style: {
                "body": Style(
                  textAlign: TextAlign.left,
                ),
                "ul": Style(
                  padding: HtmlPaddings.zero,
                  margin: Margins.zero,
                  textAlign: TextAlign.left,
                ),
                "a": Style(
                  color: Colors.blue,
                  textDecoration: TextDecoration.none,
                ),
              },
              onLinkTap: (url, attributes, element) => openBrowser(url ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/more/models/index.dart';
import 'package:pzdeals/src/features/more/presentation/widgets/card_blogpost.dart';

class BlogScreenWidget extends StatelessWidget {
  BlogScreenWidget({super.key});

  List<BlogData> blogData = [
    BlogData(
      blogTitle:
          "Throw The Best Super Bowl VLIII Party Of Your Life With These Ideas",
      blogImage:
          "https://www.pzdeals.com/cdn/shop/files/superbowl_150x.jpg?v=1707246031",
    ),
    BlogData(
      blogTitle:
          "20 Office And Desk Products To Level Up Your Productivity Right Now",
      blogImage:
          "https://www.pzdeals.com/cdn/shop/files/815FK_LVa-L._AC_SL1500_150x.jpg?v=1706731314",
    ),
    BlogData(
      blogTitle:
          "22 Must-Have Travel Items To Keep You Sane While Flying Or Driving",
      blogImage:
          "https://www.pzdeals.com/cdn/shop/files/gobe_150x.png?v=1705951881",
    ),
    BlogData(
      blogTitle: "Celebrate Tu B'Shvat At Home With These Cute Ideas!",
      blogImage:
          "https://www.pzdeals.com/cdn/shop/files/81-E4vKjqlL._AC_SL1500_150x.jpg?v=1705604873",
    ),
    BlogData(
      blogTitle: "Upgrade Your Playroom With These 22 Products",
      blogImage:
          "https://www.pzdeals.com/cdn/shop/files/playroomimage_150x.jpg?v=1705337877",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blogs',
          style: TextStyle(
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
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: blogData.length,
        padding: const EdgeInsets.only(
            top: Sizes.paddingTopSmall,
            left: Sizes.paddingLeft,
            right: Sizes.paddingRight),
        itemBuilder: (BuildContext context, int index) {
          final blog = blogData[index];
          return BlogpostCardWidget(
              blogTitle: blog.blogTitle, blogImage: blog.blogImage);
        },
      ),
    );
  }
}

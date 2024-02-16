import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/more/presentation/screens/screen_blogpost.dart';

class BlogpostCardWidget extends StatelessWidget {
  const BlogpostCardWidget(
      {super.key, required this.blogTitle, required this.blogImage});

  final String blogImage;
  final String blogTitle;

  @override
  Widget build(BuildContext context) {
    return NavigateScreenWidget(
      destinationWidget: BlogpostScreenWidget(
        title: blogTitle,
        imageAsset: blogImage,
      ),
      childWidget: Card(
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
                  child: Image.network(
                    blogImage,
                    width: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return SizedBox(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                PZColors.pzOrange),
                            backgroundColor: PZColors.pzLightGrey,
                            strokeWidth: 3,
                          ),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Sizes.paddingAll,
                        horizontal: Sizes.paddingAllSmall),
                    child: Text(
                      blogTitle,
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
      animationDirection: 'leftToRight',
    );
  }
}

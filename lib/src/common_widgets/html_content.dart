import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/constants/index.dart';

class HtmlContent extends StatelessWidget {
  const HtmlContent({
    super.key,
    required this.htmlContent,
    this.margin,
    this.padding,
  });

  final String htmlContent;
  final Margins? margin;
  final HtmlPaddings? padding;

  @override
  Widget build(BuildContext context) {
    return Html(
        shrinkWrap: false,
        data: htmlContent,
        style: {
          "body": Style(
            padding: padding ?? HtmlPaddings.zero,
            margin: margin ?? Margins.zero,
            textAlign: TextAlign.left,
          ),
          "ul": Style(
            padding: HtmlPaddings.only(left: 10.0),
            margin: Margins.zero,
            textAlign: TextAlign.left,
            lineHeight: const LineHeight(1.3),
          ),
          "li": Style(
            padding: HtmlPaddings.only(bottom: 5),
            // margin: Margins.zero,
            // textAlign: TextAlign.left,
          ),
          "a": Style(
            color: PZColors.hyperlinkColor,
            // fontWeight: FontWeight.w600,
            textDecoration: TextDecoration.none,
          ),
        },
        onLinkTap: (url, attributes, element) => openBrowser(url ?? ''));
  }
}

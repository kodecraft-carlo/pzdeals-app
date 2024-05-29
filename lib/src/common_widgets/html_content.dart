import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:pzdeals/src/actions/show_browser.dart';
import 'package:pzdeals/src/constants/index.dart';

class HtmlContent extends StatelessWidget {
  const HtmlContent(
      {super.key,
      required this.htmlContent,
      this.margin,
      this.padding,
      this.isProductDescription = false});

  final String htmlContent;
  final Margins? margin;
  final HtmlPaddings? padding;
  final bool isProductDescription;

  @override
  Widget build(BuildContext context) {
    return !isProductDescription
        ? Html(
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
                // margin: Margins.zero,
                textAlign: TextAlign.left,
                lineHeight: const LineHeight(1.3),
                display: Display.block,
              ),
              "li": Style(
                padding: HtmlPaddings.only(bottom: 15),
                // margin: Margins.zero,
                // textAlign: TextAlign.left,
              ),
              "a": Style(
                color: PZColors.hyperlinkColor,
                // fontWeight: FontWeight.w600,
                textDecoration: TextDecoration.none,
              ),
              "span": Style(
                margin: Margins.zero,
              ),
              "p": Style(
                margin: Margins.zero,
              ),
            },
            onLinkTap: (url, attributes, element) => openBrowser(url ?? ''))
        : HtmlWidget(
            htmlContent,
            customStylesBuilder: (element) {
              if (element.localName == 'body') {
                return {'line-height': '1.42857143'};
              }
              if (element.localName == 'a') {
                return {'color': '#021BF9', 'text-decoration': 'none'};
              }
              if (element.localName == 'ol') {
                return {'list-style-type': 'disc', 'padding-left': '15px'};
              }
              if (element.localName == 'ul') {
                return {'padding-left': '15px', 'margin-bottom': '10px'};
              }
              if (element.localName == 'br') {
                return {'height': '15px'};
              }
              if (element.localName == 'li') {
                return {'margin-bottom': '8px'};
              }

              if (element.localName == 'p') {
                return {
                  'margin-top': '0',
                  'margin-left': '0',
                  'margin-right': '0',
                  'margin-bottom': '10px'
                };
              }

              return null;
            },
            onLoadingBuilder: (context, element, loadingProgress) =>
                const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            renderMode: RenderMode.column,
            enableCaching: true,
            onTapUrl: (url) {
              openBrowser(url);
              return true;
            },
          );
  }
}

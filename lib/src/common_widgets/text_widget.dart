import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

enum TextDisplayType {
  appbarTitle,
  sectionTitle,
  bodyText,
  sectionSubTitle,
  cardTitle,
  cardSubtitle,
  pageTitle,
  pageSubtitle,
  smallText,
  normalText,
  largeText,
  xLargeText,
  helperText,
  hintText,
  iconTitle,
  listTitle,
  listSubtitle,
  linkText,
}

class TextWidget extends StatelessWidget {
  final String text;
  final TextDisplayType textDisplayType;
  final Color textColor;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  const TextWidget({
    super.key,
    required this.text,
    required this.textDisplayType,
    this.textColor = PZColors.pzBlack,
    this.textAlign = TextAlign.left,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize;
    FontWeight fontWeight;
    switch (textDisplayType) {
      case TextDisplayType.appbarTitle:
        fontSize = Sizes.appBarFontSize;
        fontWeight = FontWeight.w700;
        break;
      case TextDisplayType.sectionTitle:
        fontSize = Sizes.sectionHeaderFontSize;
        fontWeight = FontWeight.bold;
        break;
      case TextDisplayType.bodyText:
        fontSize = 16.0;
        fontWeight = FontWeight.normal;
        break;
      case TextDisplayType.sectionSubTitle:
        fontSize = 14.0;
        fontWeight = FontWeight.normal;
        break;
      case TextDisplayType.smallText:
        fontSize = 12.0;
        fontWeight = FontWeight.normal;
      case TextDisplayType.normalText:
        fontSize = 14.0;
        fontWeight = FontWeight.normal;

        break;
      case TextDisplayType.xLargeText:
        fontSize = 22.0;
        fontWeight = FontWeight.w700;
        break;
      default:
        fontSize = 16.0;
        fontWeight = FontWeight.normal;
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
      ),
      textAlign: textAlign,
    );
  }
}

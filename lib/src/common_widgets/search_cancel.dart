import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pzdeals/src/constants/index.dart';

class SearchCancelWidget extends StatelessWidget {
  const SearchCancelWidget({super.key, required this.destinationWidget});
  final Widget destinationWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Future.delayed(const Duration(milliseconds: 350), () {
          Platform.isAndroid
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => destinationWidget),
                )
              : Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        destinationWidget,
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
        });
      },
      child: const Text(
        "Cancel",
        style: TextStyle(
            color: PZColors.pzBlack,
            fontSize: Sizes.fontSizeMedium,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

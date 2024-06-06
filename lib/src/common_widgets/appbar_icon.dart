import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'dart:io' show Platform;

class AppbarIcon extends StatelessWidget {
  const AppbarIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Platform.isAndroid
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NavigationWidget(
                            initialPageIndex: 0,
                          )))
              : Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const NavigationWidget(
                      initialPageIndex: 0,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 100),
                  ),
                );
        },
        child: Image.asset(
          'assets/images/pzdeals.png',
          height: 28,
          width: 28,
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';

class AppbarIcon extends StatelessWidget {
  const AppbarIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavigationWidget(
                        initialPageIndex: 0,
                      )));
        },
        child: Image.asset(
          'assets/images/pzdeals.png',
          height: 28,
          width: 28,
        ));
  }
}

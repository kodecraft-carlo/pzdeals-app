import 'package:flutter/material.dart';
import 'package:pzdeals/main.dart';

class AppbarIcon extends StatelessWidget {
  const AppbarIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MainApp()));
        },
        child: Image.asset(
          'assets/images/pzdeals.png',
          height: 28,
          width: 28,
        ));
  }
}

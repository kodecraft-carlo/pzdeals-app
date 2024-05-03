import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class NavigateScreenWidget extends StatelessWidget {
  final Widget destinationWidget;
  final Widget childWidget;
  final String animationDirection;

  const NavigateScreenWidget({
    super.key,
    required this.destinationWidget,
    required this.childWidget,
    this.animationDirection = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("ScreenNavigatorWidget tapped");
        navigateToDestination(context);
      },
      child: childWidget,
    );
  }

  void navigateToDestination(BuildContext context) {
    if (Platform.isAndroid) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              destinationWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (animationDirection.isNotEmpty) {
              // Use custom slide transition if animationDirection is specified
              Offset begin;
              Offset end;

              switch (animationDirection) {
                case 'leftToRight':
                  begin = const Offset(1.0, 0.0);
                  end = Offset.zero;
                  break;
                case 'rightToLeft':
                  begin = const Offset(-1.0, 0.0);
                  end = Offset.zero;
                  break;
                case 'bottomToTop':
                  begin = const Offset(0.0, 1.0);
                  end = Offset.zero;
                  break;
                default:
                  begin = Offset.zero;
                  end = Offset.zero;
                  break;
              }

              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            } else {
              const curve = Curves.easeInOut;
              var opacityTween = Tween<double>(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: curve));
              var fadeAnimation = animation.drive(opacityTween);
              return FadeTransition(opacity: fadeAnimation, child: child);
            }
          },
        ),
      );
    } else {
      if (animationDirection == 'bottomToTop') {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                destinationWidget,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              Offset begin = const Offset(0.0, 1.0);
              ;
              Offset end = Offset.zero;

              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      } else {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => destinationWidget,
          ),
        );
      }
    }
  }
}

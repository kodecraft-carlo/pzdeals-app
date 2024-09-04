import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenAnimation extends StatelessWidget {
  const SplashScreenAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      height: height,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Lottie.asset(
              key: const Key('splashAnimation'),
              'assets/images/lottie/splash_simple_circle.json',
              // 'assets/images/lottie/launch_animation_no_droplet.json',
              width: width / 1.5,
              fit: BoxFit.cover,
              frameRate: const FrameRate(72),
            ),
            Container(
              margin: const EdgeInsets.only(top: 0), // 75
              child: Image.asset(
                key: const Key('loginScreenLogo'),
                'assets/images/pzdeals_white.png',
                height: width / 6.5,
                fit: BoxFit.fitWidth,
              ),
            )
          ],
        ),
      ),
    );
  }
}

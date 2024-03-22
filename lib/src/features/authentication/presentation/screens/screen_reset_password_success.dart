import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/button_submit.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/screen_login.dart';

class SuccessfulPasswordResetScreen extends StatefulWidget {
  final String emailAddress;

  const SuccessfulPasswordResetScreen({
    super.key,
    required this.emailAddress,
  });

  @override
  _SuccessfulPasswordResetScreenState createState() =>
      _SuccessfulPasswordResetScreenState();
}

class _SuccessfulPasswordResetScreenState
    extends State<SuccessfulPasswordResetScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  redirectToLogin(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PZColors.pzWhite,
        automaticallyImplyLeading: false,
        surfaceTintColor: PZColors.pzWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.paddingAll),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/lottie/successful.json',
              height: 200,
              fit: BoxFit.fitHeight,
              frameRate: FrameRate.max,
              controller: _controller,
              onLoaded: (composition) {
                // Configure the AnimationController with the duration of the
                // Lottie file and start the animation.
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
            const SizedBox(height: Sizes.spaceBetweenSectionsXL),
            const TextWidget(
              text: "Password Reset Email Sent",
              textDisplayType: TextDisplayType.xLargeText,
            ),
            const SizedBox(height: Sizes.spaceBetweenSections),
            Text(
              widget.emailAddress,
              style: const TextStyle(
                  fontSize: Sizes.fontSizeMedium,
                  fontWeight: FontWeight.w600,
                  color: PZColors.pzGrey),
            ),
            const SizedBox(height: Sizes.spaceBetweenSections),
            const TextWidget(
              text:
                  "If the email address you provided is registered with us, you will receive an email with instructions on how to reset your password.",
              textDisplayType: TextDisplayType.sectionSubTitle,
            ),
            const SizedBox(height: Sizes.spaceBetweenSectionsXL),
            Row(
              children: [
                Expanded(
                  child: SubmitButtonWidget(
                    onSubmit: () {
                      redirectToLogin(context);
                    },
                    buttonLabel: const Text(
                      "Done",
                      style: TextStyle(
                        fontSize: Sizes.fontSizeLarge,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

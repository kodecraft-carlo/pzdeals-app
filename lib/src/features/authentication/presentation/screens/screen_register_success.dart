import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pzdeals/src/common_widgets/button_submit.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/screen_login.dart';

class SuccessfulRegistrationScreen extends StatefulWidget {
  final String firstName;

  const SuccessfulRegistrationScreen({
    super.key,
    required this.firstName,
  });

  @override
  _SuccessfulRegistrationScreenState createState() =>
      _SuccessfulRegistrationScreenState();
}

class _SuccessfulRegistrationScreenState
    extends State<SuccessfulRegistrationScreen> with TickerProviderStateMixin {
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
    double screenHeight = MediaQuery.of(context).size.height;
    double itemHeight = screenHeight / 2.5;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PZColors.pzWhite,
        automaticallyImplyLeading: false,
        surfaceTintColor: PZColors.pzWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.paddingAll),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(alignment: Alignment.center, children: [
              Lottie.asset(
                key: const Key('successConfetti'),
                'assets/images/lottie/confetti.json',
                height: itemHeight,
                frameRate: FrameRate.max,
                fit: BoxFit.fitHeight,
              ),
              Image.asset(
                key: const Key('screenLogo'),
                'assets/images/pzdeals.png',
                height: 80,
                fit: BoxFit.fitHeight,
              ),
            ]),
            const SizedBox(height: Sizes.spaceBetweenSectionsXL),
            TextWidget(
              text: "Welcome to PZ Deals, ${widget.firstName}!",
              textDisplayType: TextDisplayType.xLargeText,
            ),
            const SizedBox(height: Sizes.spaceBetweenSections),
            const TextWidget(
              text:
                  "Thank you for registering with us! You can now start using your account to access all the features of PZ Deals.",
              textDisplayType: TextDisplayType.sectionSubTitle,
              textAlign: TextAlign.center,
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
                      "Login Now",
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

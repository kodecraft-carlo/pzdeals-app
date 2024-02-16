import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pzdeals/src/common_widgets/button_login_with.dart';
import 'package:pzdeals/src/constants/index.dart';

class LoginRequiredScreen extends StatelessWidget {
  const LoginRequiredScreen(
      {super.key,
      this.message = 'Login to unlock this feature!',
      this.hasCloseButton = true});

  final String message;
  final bool hasCloseButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: hasCloseButton == true
            ? AppBar(
                backgroundColor: PZColors.pzWhite,
                automaticallyImplyLeading: false,
                surfaceTintColor: PZColors.pzWhite,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    iconSize: Sizes.screenCloseIconSize,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : null,
        body: Padding(
          padding: const EdgeInsets.all(Sizes.paddingAll),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message,
                style: const TextStyle(
                    fontSize: Sizes.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: PZColors.pzBlack),
              ),
              const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              Stack(alignment: Alignment.center, children: [
                SvgPicture.asset('assets/images/login_required.svg'),
                Positioned(
                  top: 90,
                  child: Image.asset(
                    'assets/images/pzdeals.png',
                    height: 50,
                    fit: BoxFit.fitHeight,
                  ),
                )
              ]),
              const SizedBox(height: Sizes.spaceBetweenSectionsXL),
              ButtonLoginWith(
                  buttonLabel: 'Login via Facebook',
                  imageAsset: 'assets/images/logins/facebook.png',
                  onButtonPressed: () {
                    debugPrint("login via facebook");
                  }),
              const SizedBox(height: Sizes.spaceBetweenContentSmall),
              ButtonLoginWith(
                  buttonLabel: 'Login via Google',
                  imageAsset: 'assets/images/logins/google.png',
                  onButtonPressed: () {
                    debugPrint("login via google");
                  }),
              const SizedBox(height: Sizes.spaceBetweenContentSmall),
              ButtonLoginWith(
                  buttonLabel: 'Login via Apple',
                  imageAsset: 'assets/images/logins/apple.png',
                  onButtonPressed: () {
                    debugPrint("login via apple");
                  }),
            ],
          )),
        ));
  }
}

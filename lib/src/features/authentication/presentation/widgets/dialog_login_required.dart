import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pzdeals/src/actions/material_navigate_screen.dart';
import 'package:pzdeals/src/actions/show_dialog.dart';
import 'package:pzdeals/src/common_widgets/button_login_with.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/index.dart';
import 'package:pzdeals/src/features/authentication/presentation/widgets/google_signin.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/state/auth_provider.dart';

class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double dialogHeight = screenHeight / 1.5;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        surfaceTintColor: PZColors.pzWhite,
        backgroundColor: PZColors.pzWhite,
        shadowColor: PZColors.pzBlack,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.dialogBorderRadius),
        ),
        child: SizedBox(
            height: dialogHeight,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.paddingAll * 1.2,
                    vertical: Sizes.paddingAll * 2),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Login to PzDeals',
                        style: TextStyle(
                            fontSize: Sizes.fontSizeMedium,
                            fontWeight: FontWeight.w600,
                            color: PZColors.pzBlack),
                      ),
                      const SizedBox(height: Sizes.spaceBetweenSectionsXL),
                      Stack(alignment: Alignment.center, children: [
                        SvgPicture.asset(
                          'assets/images/login_required.svg',
                          width: MediaQuery.of(context).size.width / 2.2,
                        ),
                        Positioned(
                          top: 40,
                          child: Image.asset(
                            'assets/images/pzdeals.png',
                            height: 40,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      ]),
                      const SizedBox(height: Sizes.spaceBetweenSectionsXL),
                      Consumer(builder: (context, ref, child) {
                        return GoogleSignInButton(
                            clickableWidget: ButtonLoginWith(
                                buttonLabel: 'Login via Google',
                                imageAsset: 'assets/images/logins/google.png',
                                onButtonPressed: () async {
                                  final authService = ref.watch(authProvider);
                                  final User? user =
                                      await authService.signInWithGoogle();
                                  if (user != null) {
                                    debugPrint(
                                        'Signed in with Google: ${user.displayName}');
                                    if (context.mounted) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NavigationWidget(
                                                    initialPageIndex: 0,
                                                  )));
                                    }
                                  } else {
                                    if (context.mounted) {
                                      showMessageDialog(
                                          context,
                                          "Sign-in Failed",
                                          "Sorry we can't sign you in at the moment.",
                                          () {
                                        Navigator.pop(context);
                                      }, 'OK');
                                    }
                                    debugPrint('Google sign-in failed.');
                                  }
                                }));
                      }),

                      const SizedBox(height: Sizes.spaceBetweenContentSmall),
                      ButtonLoginWith(
                          buttonLabel: 'Login via Email',
                          imageAsset: 'assets/images/logins/mail.png',
                          onButtonPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          }),
                      const SizedBox(height: Sizes.spaceBetweenSectionsXL),
                      const MaterialNavigateScreen(
                          childWidget: Text("No account yet? Sign Up",
                              style: TextStyle(
                                  color: PZColors.pzOrange,
                                  fontSize: Sizes.fontSizeMedium,
                                  fontWeight: FontWeight.w600)),
                          destinationScreen: RegisterScreen()),
                      // ButtonLoginWith(
                      //     buttonLabel: 'Login via Facebook',
                      //     imageAsset: 'assets/images/logins/facebook.png',
                      //     onButtonPressed: () {
                      //       debugPrint("login via facebook");
                      //     }),
                      // const SizedBox(height: Sizes.spaceBetweenContentSmall),
                      // ButtonLoginWith(
                      //     buttonLabel: 'Login via Apple',
                      //     imageAsset: 'assets/images/logins/apple.png',
                      //     onButtonPressed: () {
                      //       debugPrint("login via apple");
                      //     }),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

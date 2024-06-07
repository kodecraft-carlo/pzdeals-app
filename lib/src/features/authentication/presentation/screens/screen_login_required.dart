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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                iconSize: Sizes.screenCloseIconSize,
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) {
                  //   return const NavigationWidget();
                  // }));
                  Navigator.pop(context);
                },
              ),
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
            Consumer(builder: (context, ref, child) {
              return GoogleSignInButton(
                  clickableWidget: ButtonLoginWith(
                      buttonLabel: 'Login via Google',
                      imageAsset: 'assets/images/logins/google.png',
                      onButtonPressed: () async {
                        final authService = ref.watch(authProvider);
                        final User? user = await authService.signInWithGoogle();
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
                            showMessageDialog(context, "Sign-in Failed",
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
        )),
      ),
    );
  }
}

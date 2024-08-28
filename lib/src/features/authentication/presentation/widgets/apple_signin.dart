import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/show_dialog.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/state/auth_provider.dart';

class AppleSignInButton extends ConsumerWidget {
  final Widget clickableWidget;

  const AppleSignInButton({super.key, required this.clickableWidget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onTap: () async {
          final User? user = await ref.read(authProvider).signInWithApple();
          if (user != null) {
            debugPrint('Signed in with Apple: ${user.displayName}');
            if (context.mounted) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NavigationWidget()));
            }
          } else {
            if (context.mounted) {
              showMessageDialog(context, "Sign-in Failed",
                  "Sorry we can't sign you in at the moment.", () {
                Navigator.pop(context);
              }, 'OK');
            }
            debugPrint('Google sign-in failed.');
          }
        },
        child: clickableWidget);
  }
}

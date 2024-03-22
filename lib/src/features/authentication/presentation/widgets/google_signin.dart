import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/main.dart';
import 'package:pzdeals/src/actions/show_dialog.dart';
import 'package:pzdeals/src/state/auth_provider.dart';

class GoogleSignInButton extends ConsumerWidget {
  final Widget clickableWidget;

  const GoogleSignInButton({super.key, required this.clickableWidget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onTap: () async {
          final authService = ref.watch(authProvider);
          final User? user = await authService.signInWithGoogle();
          if (user != null) {
            debugPrint('Signed in with Google: ${user.displayName}');
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

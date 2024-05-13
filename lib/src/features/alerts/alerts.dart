import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/screen_login_required.dart';
import 'package:pzdeals/src/features/alerts/presentation/screens/screen_alerts_management.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';

class DealAlertsScreen extends StatelessWidget {
  const DealAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final authUserState = ref.watch(authUserDataProvider);
      if (authUserState.isAuthenticated == true) {
        return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NavigationWidget(
                            initialPageIndex: 0,
                          )));
            },
            child: const AlertsManagementScreen());
      } else {
        return const LoginRequiredScreen(
          hasCloseButton: false,
        );
      }
    });
  }
}

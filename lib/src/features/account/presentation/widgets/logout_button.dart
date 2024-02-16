import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Sizes.buttonBorderRadius),
                  ),
                  backgroundColor: PZColors.pzOrange,
                  minimumSize: const Size(150, 40),
                  elevation: Sizes.buttonElevation),
              onPressed: () {
                debugPrint('Logout pressed');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    color: PZColors.pzWhite,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                        color: PZColors.pzWhite, fontWeight: FontWeight.w600),
                  ),
                ],
              ))),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:pzdeals/src/actions/material_navigate_screen.dart';
import 'package:pzdeals/src/features/authentication/presentation/screens/screen_login_required.dart';
import 'package:pzdeals/src/constants/index.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: PZColors.pzOrange,
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.all(
              Sizes.paddingAll,
            ),
            child: MaterialNavigateScreen(
                childWidget: Row(
                  children: [
                    const Icon(Icons.account_circle_outlined,
                        color: PZColors.pzWhite),
                    const SizedBox(width: Sizes.paddingAllSmall),
                    Expanded(
                      child: RichText(
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: const TextSpan(
                          text: 'Please ',
                          style: TextStyle(
                            color: PZColors.pzWhite,
                            fontFamily: 'Poppins',
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PZColors.pzWhite,
                                    fontFamily: 'Poppins')),
                            TextSpan(
                                text:
                                    ' to unlock all of ${Wordings.appName} features!',
                                style: TextStyle(
                                    color: PZColors.pzWhite,
                                    fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                destinationScreen: const LoginRequiredScreen(
                  message:
                      "Login to unlock amazing ${Wordings.appName} features!",
                ))));
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:pzdeals/src/actions/show_dialog.dart';
import 'package:pzdeals/src/common_widgets/loading_dialog.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/models/user_data.dart';
import 'package:pzdeals/src/state/auth_provider.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'package:pzdeals/src/utils/formatter/date_formatter.dart';
import 'package:pzdeals/src/utils/helpers/convert_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountCard extends ConsumerStatefulWidget {
  const AccountCard({super.key, required this.accountData});
  final UserData accountData;
  @override
  AccountCardState createState() => AccountCardState();
}

class AccountCardState extends ConsumerState<AccountCard> {
  final TextEditingController _passwordController = TextEditingController();

  late String signInMethod;

  @override
  void initState() {
    super.initState();
    initSignInMethod();
  }

  Future<void> initSignInMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    signInMethod =
        prefs.getString('signInMethod') ?? ref.read(authProvider).signInMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: PZColors.pzLightGrey,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              isThreeLine: false,
              leading: const Icon(
                Icons.account_circle,
                size: Sizes.listIconSize,
                color: Colors.amber,
              ),
              title: Text(
                'Welcome, ${widget.accountData.firstName}!',
                style: const TextStyle(
                    color: PZColors.pzOrange,
                    fontWeight: FontWeight.w700,
                    fontSize: Sizes.listTitleFontSize),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.accountData.emailAddress!,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: Sizes.bodySmallSize,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Registered: ${formatDateToDisplay(widget.accountData.dateRegistered!, 'MMM dd, yyyy').toString()}',
                    style: const TextStyle(
                        color: Colors.black54, fontSize: Sizes.bodySmallSize),
                  )
                ],
              ),
              trailing: ref.watch(authUserDataProvider).isAuthenticated == true
                  ? PullDownButton(
                      itemBuilder: (context) => [
                        PullDownMenuItem(
                          enabled: true,
                          title: 'Delete Account',
                          onTap: () {
                            showDeleteAccountConfirmationDialog(context, ref);
                          },
                          itemTheme: PullDownMenuItemTheme(
                            textStyle: TextStyle(
                              color: Platform.isIOS
                                  ? CupertinoColors.destructiveRed
                                  : Colors.red,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          icon: Platform.isIOS
                              ? CupertinoIcons.person_crop_circle_badge_xmark
                              : Icons.person_remove,
                        ),
                      ],
                      buttonBuilder: (context, showMenu) => GestureDetector(
                        onTap: showMenu,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          color: PZColors.pzLightGrey,
                          child: Icon(
                            Platform.isIOS
                                ? CupertinoIcons.ellipsis_vertical
                                : Icons.more_vert,
                            color: PZColors.pzOrange,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ));
  }

  void showDeleteAccountConfirmationDialog(
      BuildContext context, WidgetRef ref) {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: false,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text(
                  "Delete Account",
                  style: TextStyle(
                      fontSize: Sizes.fontSizeLarge,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.destructiveRed),
                ),
                content: Column(
                  children: [
                    const Text(
                      Wordings.deleteAccountMessage,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Divider(color: CupertinoColors.systemGrey),
                    signInMethod == 'email'
                        ? const Text(
                            "Please enter your password to confirm",
                          )
                        : const SizedBox(),
                    signInMethod == 'google' || signInMethod == 'apple'
                        ? Text(
                            "You may be asked to sign in with your ${capitalizeFirstLetter(signInMethod)} account again to confirm",
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 5,
                    ),
                    signInMethod == 'email'
                        ? CupertinoTextField(
                            controller: _passwordController,
                            placeholder: 'Password',
                            obscureText: true,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              border:
                                  Border.all(color: CupertinoColors.systemGrey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onChanged: (value) {},
                          )
                        : const SizedBox(),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () {
                      _passwordController.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  CupertinoDialogAction(
                    onPressed: () async {
                      if (signInMethod == 'email' &&
                          _passwordController.text.trim().isEmpty) {
                        return;
                      }
                      LoadingDialog.show(context,
                          message: "Please wait this may take a while");
                      if (await ref.read(authProvider).reauthenticateUser(
                          _passwordController.text.trim())) {
                        await ref.read(authProvider).deleteAccount();
                        debugPrint('User deleted account');
                        if (context.mounted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NavigationWidget()));
                        }
                      } else {
                        _passwordController.clear();

                        if (context.mounted) {
                          LoadingDialog.hide(context);
                          showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Error'),
                                  content: signInMethod == 'email'
                                      ? const Text('Invalid password')
                                      : const Text(
                                          'Unable to complete request. Please try again.'),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK',
                                          style: TextStyle(
                                              color:
                                                  CupertinoColors.activeBlue)),
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    },
                    isDestructiveAction: true,
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: CupertinoColors.destructiveRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        : showDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: false,
            builder: (BuildContext context) {
              return AlertDialog.adaptive(
                surfaceTintColor: Colors.transparent,
                backgroundColor: PZColors.pzWhite,
                title: const Text(
                  "Delete Account",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      Wordings.deleteAccountMessage,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Divider(color: CupertinoColors.systemGrey),
                    const SizedBox(
                      height: 5,
                    ),
                    signInMethod == 'email'
                        ? const Text(
                            "Please enter your password to confirm",
                          )
                        : const SizedBox(),
                    signInMethod == 'google' || signInMethod == 'apple'
                        ? Text(
                            "You may be asked to sign in with your ${capitalizeFirstLetter(signInMethod)} account again to confirm",
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 5,
                    ),
                    signInMethod == 'email'
                        ? TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: PZColors.pzGrey, width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                  gapPadding: 0),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: PZColors.pzOrange, width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                  gapPadding: 0),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                            ),
                            onChanged: (value) {},
                          )
                        : const SizedBox(),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: PZColors.pzBlack),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (signInMethod == 'email' &&
                          _passwordController.text.trim().isEmpty) {
                        return;
                      }

                      LoadingDialog.show(context,
                          message: "Please wait this may take a while");
                      if (await ref.read(authProvider).reauthenticateUser(
                          _passwordController.text.trim())) {
                        await ref.read(authProvider).deleteAccount();
                        debugPrint('User deleted account');
                        if (context.mounted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NavigationWidget()));
                        }
                      } else {
                        _passwordController.clear();

                        if (context.mounted) {
                          LoadingDialog.hide(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog.adaptive(
                                  title: const Text('Error'),
                                  content: ref
                                              .read(authProvider)
                                              .signInMethod ==
                                          'email'
                                      ? const Text('Invalid password')
                                      : const Text(
                                          'Unable to complete request. Please try again.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK',
                                          style: TextStyle(
                                              color: PZColors.pzOrange)),
                                    )
                                  ],
                                );
                              });
                        }
                      }

                      // await ref.read(authProvider).deleteAccount();
                      // debugPrint('User deleted account');
                      // if (context.mounted) {
                      //   Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) =>
                      //               const NavigationWidget()));
                      // }
                    },
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/input_dialog.dart';
import 'package:pzdeals/src/common_widgets/square_labeled_icons.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_cc_deals.dart';
import 'package:pzdeals/src/features/more/presentation/screens/index.dart';
import 'package:pzdeals/src/services/google_sheet_service.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';

class MoreShortcutsWidget extends ConsumerStatefulWidget {
  const MoreShortcutsWidget({
    super.key,
  });
  @override
  MoreShortcutsWidgetState createState() => MoreShortcutsWidgetState();
}

class MoreShortcutsWidgetState extends ConsumerState<MoreShortcutsWidget> {
  // EmailService emailSvc = EmailService();
  GoogleSheetService googletSheetSvc = GoogleSheetService();
  String storeName = '';
  TextEditingController dialogFieldController = TextEditingController();

  void submitRequest(String requestType, String? email) {
    if (requestType == 'wish_list') {
      googletSheetSvc.notifyWishlisht('?timestamp=${DateTime.now()}'
          '&email=${email ?? dialogFieldController.text}');
    } else if (requestType == 'flights') {
      googletSheetSvc.notifyFlights('?timestamp=${DateTime.now()}'
          '&email=${email ?? dialogFieldController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 4;
    final authUserDataState = ref.watch(authUserDataProvider);
    return GridView.count(
      padding: const EdgeInsets.all(Sizes.paddingAll),
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 15,
      childAspectRatio: 2 / 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        NavigateScreenWidget(
          destinationWidget: const CreditCardDealsScreen(),
          childWidget: SquareLabeledIcon(
            iconTitle: 'Credit Cards',
            iconImage: 'assets/images/shortcuts/creditcards.png',
            iconAssetType: 'asset',
            borderColor: Colors.yellow.shade700,
          ),
        ),
        NavigateScreenWidget(
          destinationWidget: const BlogScreenWidget(),
          childWidget: SquareLabeledIcon(
            iconTitle: 'Blog',
            iconImage: 'assets/images/shortcuts/blogs.png',
            iconAssetType: 'asset',
            borderColor: Colors.blue.shade900,
          ),
        ),
        const NavigateScreenWidget(
          destinationWidget: BookmarkedScreenWidget(),
          childWidget: SquareLabeledIcon(
            iconTitle: 'Bookmarks',
            iconImage: 'assets/images/shortcuts/bookmark.png',
            iconAssetType: 'asset',
            borderColor: Colors.blue,
          ),
        ),
        GestureDetector(
          onTap: () {
            dialogFieldController.clear();
            Platform.isIOS
                ? showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return CommonInputDialog(
                        dialogMessage:
                            "Stay tuned! This feature is coming soon.",
                        inputHint: "Email address",
                        snackbarMessage:
                            "Thank you for your interest! We'll keep you updated.",
                        dialogFieldController: dialogFieldController,
                        onButtonPressed: () => submitRequest('wish_list',
                            authUserDataState.userData?.emailAddress),
                        buttonText: 'Notify me',
                        isButtonOnly: authUserDataState.isAuthenticated,
                      );
                    },
                  )
                : showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CommonInputDialog(
                        dialogMessage:
                            "Stay tuned! This feature is coming soon.",
                        inputHint: "Email address",
                        snackbarMessage:
                            "Thank you for your interest! We'll keep you updated.",
                        dialogFieldController: dialogFieldController,
                        onButtonPressed: () => submitRequest('wish_list',
                            authUserDataState.userData?.emailAddress),
                        buttonText: 'Notify me',
                        isButtonOnly: authUserDataState.isAuthenticated,
                      );
                    },
                  );
          },
          child: SquareLabeledIcon(
            iconTitle: 'Wish List',
            iconImage: 'assets/images/shortcuts/wishlist.png',
            iconAssetType: 'asset',
            borderColor: Colors.red.shade600,
          ),
        ),
        GestureDetector(
          onTap: () {
            dialogFieldController.clear();
            Platform.isIOS
                ? showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return CommonInputDialog(
                        dialogMessage:
                            "Stay tuned! This feature is coming soon.",
                        inputHint: "Email address",
                        snackbarMessage:
                            "Thank you for your interest! We'll keep you updated.",
                        dialogFieldController: dialogFieldController,
                        onButtonPressed: () => submitRequest('flights',
                            authUserDataState.userData?.emailAddress),
                        buttonText: 'Notify me',
                        isButtonOnly: authUserDataState.isAuthenticated,
                      );
                    },
                  )
                : showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CommonInputDialog(
                        dialogMessage:
                            "Stay tuned! This feature is coming soon.",
                        inputHint: "Email address",
                        snackbarMessage:
                            "Thank you for your interest! We'll keep you updated.",
                        dialogFieldController: dialogFieldController,
                        onButtonPressed: () => submitRequest('flights',
                            authUserDataState.userData?.emailAddress),
                        buttonText: 'Notify me',
                        isButtonOnly: authUserDataState.isAuthenticated,
                      );
                    },
                  );
          },
          child: SquareLabeledIcon(
            iconTitle: 'Flights',
            iconImage: 'assets/images/shortcuts/plane.png',
            iconAssetType: 'asset',
            borderColor: Colors.blueGrey.shade400,
          ),
        ),
      ],
    );
  }
}

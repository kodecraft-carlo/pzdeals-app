import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/models/user_data.dart';
import 'package:pzdeals/src/utils/formatter/date_formatter.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key, required this.accountData});

  final UserData accountData;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: PZColors.pzLightGrey,
        elevation: 0,
        child: ListTile(
            leading: const Icon(
              Icons.account_circle,
              size: Sizes.listIconSize,
              color: Colors.amber,
            ),
            title: Text(
              'Welcome, ${accountData.firstName} ${accountData.lastName}!',
              style: const TextStyle(
                  color: PZColors.pzOrange,
                  fontWeight: FontWeight.w700,
                  fontSize: Sizes.listTitleFontSize),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accountData.emailAddress!,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: Sizes.bodySmallSize,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  'Registered: ${formatDateToDisplay(accountData.dateRegistered!, 'MMM dd, yyyy').toString()}',
                  style: const TextStyle(
                      color: Colors.black54, fontSize: Sizes.bodySmallSize),
                )
              ],
            )));
  }
}

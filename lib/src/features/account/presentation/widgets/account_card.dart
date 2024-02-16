import 'package:flutter/material.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/account/models/index.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key, required this.accountData});

  final AccountData accountData;
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
              accountData.email,
              style: const TextStyle(
                  color: PZColors.pzOrange,
                  fontWeight: FontWeight.w700,
                  fontSize: Sizes.listTitleFontSize),
            ),
            subtitle: Text(
              accountData.registeredDate,
              style: const TextStyle(
                  color: Colors.black54, fontSize: Sizes.bodySmallSize),
            )));
  }
}

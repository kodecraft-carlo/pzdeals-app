import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/list_tile_switch.dart';
import 'package:pzdeals/src/common_widgets/slider.dart';
import 'package:pzdeals/src/common_widgets/text_field.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/account/presentation/widgets/index.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> pills = [
      'Airpods',
      'iPhone',
      'Nike Panda',
      'Apple Watch series 9',
      'New Balance 550',
      'Veja CWL V-10',
      'JBL Speaker',
    ];

    TextEditingController textEditingController = TextEditingController();
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(Sizes.paddingAll),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Notification Settings",
                  style: TextStyle(
                      fontSize: Sizes.sectionHeaderFontSize,
                      fontWeight: FontWeight.w600,
                      color: PZColors.pzBlack),
                ),
                const SizedBox(height: Sizes.spaceBetweenContent),
                const ListTileWithSwitchWidget(
                  title: 'Price Mistake',
                  subtitle:
                      'Get notified about significant drops in the price of a product',
                  value: true,
                ),
                const ListTileWithSwitchWidget(
                  title: 'Front Page Notifications',
                  subtitle:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  value: false,
                ),
                const SizedBox(height: Sizes.spaceBetweenSections),
                const Text("Number of alerts to receive",
                    style: TextStyle(
                        fontSize: Sizes.listTitleFontSize,
                        fontWeight: FontWeight.w500)),
                const SliderWidget(),
                const ListTileWithSwitchWidget(
                  title: '% Off Notifications',
                  subtitle:
                      'Get notified about significant drops in the price of a product',
                  value: true,
                ),
                TextFieldWidget(
                  hintText: 'Set % Off Threshold',
                  obscureText: false,
                  controller: textEditingController,
                  keyboardType: TextInputType.text,
                  isDense: true,
                ),
                const SizedBox(height: Sizes.spaceBetweenSectionsXL),
                Consumer(builder: (context, ref, child) {
                  final authUserState = ref.watch(authUserDataProvider);
                  if (authUserState.isAuthenticated == true) {
                    return Column(
                      children: [
                        KeywordAlertsSection(savedKeywords: pills),
                        const SizedBox(
                          height: Sizes.spaceBetweenSectionsXL,
                        ),
                        const LogoutButton()
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                })
              ],
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/dropdown_widget.dart';
import 'package:pzdeals/src/common_widgets/list_tile_switch.dart';
import 'package:pzdeals/src/constants/index.dart';
import 'package:pzdeals/src/features/account/presentation/widgets/index.dart';
import 'package:pzdeals/src/features/account/state/settings_provider.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'package:pzdeals/src/utils/field_validation/index.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  String? _selectedThreshold = '10';
  double alertsCount = 10;

  bool isPriceMistake = false;
  bool isFrontPage = false;
  bool isPercentOff = false;

  void onPriceMistakeChanged(bool value) {
    setState(() {
      isPriceMistake = value;
    });
    ref
        .read(settingsProvider)
        .updateSettingsLocally(isPriceMistake, 'priceMistake');
  }

  void onFrontPageChanged(bool value) {
    setState(() {
      isFrontPage = value;
    });
    final setting = {
      'frontPage': isFrontPage,
      'alertCount': isFrontPage ? alertsCount.round() : 0,
    };
    ref.read(settingsProvider).updateSettingsLocally(setting, 'frontPage');
  }

  void alertsOnChanged(double value) {
    setState(() {
      alertsCount = value;
    });
    final setting = {
      'frontPage': isFrontPage,
      'alertCount': isFrontPage ? alertsCount.round() : 0,
    };

    Future.delayed(const Duration(milliseconds: 300), () {
      ref.read(settingsProvider).updateSettingsLocally(setting, 'frontPage');
    });
  }

  void onPercentOffChanged(bool value) {
    setState(() {
      isPercentOff = value;
    });
    final setting = {
      'percentOff': isPercentOff,
      'threshold': isPercentOff ? _selectedThreshold : '0'
    };
    ref.read(settingsProvider).updateSettingsLocally(setting, 'percentOff');
  }

  void thresholdOnChanged(String? value) {
    setState(() {
      _selectedThreshold = value;
    });
    final setting = {
      'percentOff': isPercentOff,
      'threshold': isPercentOff ? _selectedThreshold : '0'
    };
    ref.read(settingsProvider).updateSettingsLocally(setting, 'percentOff');
  }

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(settingsProvider).loadUserSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authUserDataProvider);
    final settingsState = ref.watch(settingsProvider);
    List<String> dropdownItems = [
      '10',
      '20',
      '30',
      '40',
      '50',
      '60',
      '70',
      '80',
      '90',
      '100'
    ];
    isPercentOff =
        !settingsState.isLoading && settingsState.settingsData != null
            ? settingsState.settingsData!.percentageNotification
            : false;

    isFrontPage = !settingsState.isLoading && settingsState.settingsData != null
        ? settingsState.settingsData!.frontpageNotification
        : false;

    alertsCount = !settingsState.isLoading && settingsState.settingsData != null
        ? settingsState.settingsData!.numberOfAlerts.toDouble()
        : 10;

    _selectedThreshold =
        !settingsState.isLoading && settingsState.settingsData != null
            ? settingsState.settingsData!.percentageThreshold.toString()
            : '10';
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
                // 04/04/2024 demo: Price mistake alert (turned on by default and remove on settings)
                // ListTileWithSwitchWidget(
                //   title: 'Price Mistake',
                //   subtitle:
                //       'Get notified about significant drops in the price of a product',
                //   value: !settingsState.isLoading &&
                //           settingsState.settingsData != null
                //       ? settingsState.settingsData!.priceMistake
                //       : false,
                //   onChanged: onPriceMistakeChanged,
                // ),
                ListTileWithSwitchWidget(
                  title: 'Front Page Notifications',
                  subtitle: 'Get notified about front page deals',
                  value: !settingsState.isLoading &&
                          settingsState.settingsData != null
                      ? settingsState.settingsData!.frontpageNotification
                      : false,
                  onChanged: onFrontPageChanged,
                ),
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isFrontPage
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                  height: Sizes.spaceBetweenSections),
                              const Text("Number of alerts to receive",
                                  style: TextStyle(
                                      fontSize: Sizes.listTitleFontSize,
                                      fontWeight: FontWeight.w500)),
                              SliderWidget(
                                onChanged: alertsOnChanged,
                                initialValue:
                                    alertsCount.round() == 0 ? 10 : alertsCount,
                              ),
                            ],
                          )
                        : const SizedBox()),
                ListTileWithSwitchWidget(
                  title: '% Off Notifications',
                  subtitle:
                      'Get notified about significant drops in the price of a product',
                  value: isPercentOff,
                  onChanged: onPercentOffChanged,
                ),
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isPercentOff
                        ? DropdownWidget(
                            onChanged: thresholdOnChanged,
                            isDense: true,
                            initialValue: _selectedThreshold == '0'
                                ? '10'
                                : _selectedThreshold,
                            dropdownLabel: '% Off Threshold',
                            dropdownItems: dropdownItems,
                            validator: thresholdValidator,
                          )
                        : const SizedBox()),
                const SizedBox(height: Sizes.spaceBetweenSectionsXL),
                authUserState.isAuthenticated == true
                    ? const Column(
                        children: [
                          // KeywordAlertsSection(),
                          SizedBox(
                            height: Sizes.spaceBetweenSectionsXL,
                          ),
                          LogoutButton()
                        ],
                      )
                    : const SizedBox()
              ],
            )));
  }
}

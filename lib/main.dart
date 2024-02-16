import 'package:flutter/material.dart';
import 'package:pzdeals/src/features/alerts/alerts.dart';
import 'package:pzdeals/src/features/more/more.dart';
import 'package:pzdeals/src/features/notifications/notifications.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/features/stores/stores.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const NavigationWidget(),
    );
  }
}

class NavigationWidget extends StatefulWidget {
  final int initialPageIndex;
  const NavigationWidget({super.key, this.initialPageIndex = 0});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              selectedIndex: currentPageIndex,
              indicatorColor: Colors.transparent,
              backgroundColor: Colors.white,
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
              surfaceTintColor: Colors.white,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.local_offer_rounded),
                  icon: Icon(Icons.local_offer_outlined),
                  label: 'Deals',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.store_rounded),
                  icon: Icon(Icons.store_outlined),
                  label: 'Stores',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.notifications_active_rounded),
                  icon: Icon(Icons.notifications_outlined),
                  label: 'Notification',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.campaign_rounded),
                  icon: Icon(Icons.campaign_outlined),
                  label: 'Deal Alert',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.more_horiz),
                  icon: Icon(Icons.more_horiz),
                  label: 'More',
                ),
              ],
            ),
          )),
      body: SafeArea(
          child: <Widget>[
        const DealsTabControllerWidget(),
        StoresWidget(),
        NotificationScreen(),
        DealAlertsScreen(),
        MoreScreen()
      ][currentPageIndex]),
    );
  }
}

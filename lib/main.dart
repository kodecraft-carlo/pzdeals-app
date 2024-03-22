import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pzdeals/firebase_options.dart';
import 'package:pzdeals/src/features/alerts/alerts.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_keyword_deals.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_percentage_deals.dart';
import 'package:pzdeals/src/features/more/models/blogs_data.dart';
import 'package:pzdeals/src/features/more/more.dart';
import 'package:pzdeals/src/features/notifications/notifications.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:pzdeals/src/features/stores/state/provider_stores.dart';
import 'package:pzdeals/src/features/stores/stores.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/models/index.dart';
import 'package:pzdeals/src/services/firebase_messaging.dart';
import 'package:pzdeals/src/services/notifications_service.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'package:pzdeals/src/state/bookmarks_provider.dart';
import 'package:pzdeals/src/state/directus_auth_service.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';

final navigatorKey = GlobalKey<NavigatorState>();
NotificationService notifService = NotificationService();
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('remotemessage ${jsonEncode(message.toMap().toString())}');
  await Firebase.initializeApp();
  notifService.addNotification(
      NotificationMapper.mapToNotificationData(message), 'notifications');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessagingApi().initNotifications();
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(ProductDealcardDataAdapter());
  Hive.registerAdapter(CreditCardDealDataAdapter());
  Hive.registerAdapter(CollectionDataAdapter());
  Hive.registerAdapter(PZStoreDataAdapter());
  Hive.registerAdapter(StoreDataAdapter());
  Hive.registerAdapter(NotificationDataAdapter());
  Hive.registerAdapter(BlogDataAdapter());
  runApp(ProviderScope(child: MainApp()));
}

final bookmarkedproductsProvider =
    ChangeNotifierProvider<BookmarkedProductsNotifier>((ref) {
  final bookmarksNotifier = BookmarkedProductsNotifier();

  ref.onDispose(() {
    bookmarksNotifier.dispose();
  });

  if (ref.watch(authUserDataProvider).isAuthenticated) {
    bookmarksNotifier.setUserUID(ref.read(authUserDataProvider).userData!.uid);
  }
  return bookmarksNotifier;
});

class MainApp extends ConsumerWidget {
  MainApp({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldKey,
      navigatorKey: navigatorKey,
      routes: {
        '/keyword-deals': (context) => const KeywordDealsScreen(),
        '/percentage-deals': (context) => const PercentageDealsScreen(),
      },
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent),
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const NavigationWidget(),
    );
  }
}

class NavigationWidget extends ConsumerStatefulWidget {
  final int initialPageIndex;
  const NavigationWidget({super.key, this.initialPageIndex = 0});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NavigationWidgetState();
}

class _NavigationWidgetState extends ConsumerState<NavigationWidget> {
  late int currentPageIndex;
  late AsyncValue<UserData?> userData;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = ref.read(directusAuthServiceProvider);
      // authService.login().then((_) {
      //   debugPrint(
      //       "${DateTime.now()}: directus login successful ${authService.getAccessToken()}");
      //   refreshTokenPeriodically(ref);
      // }).catchError((error) {
      //   debugPrint('directus login error $error');
      // });
    });
  }

  void refreshTokenPeriodically(WidgetRef ref) {
    final authService = ref.read(directusAuthServiceProvider);
    Timer.periodic(const Duration(minutes: 13), (timer) {
      authService.refreshTokens().then((_) {
        debugPrint('${DateTime.now()}: Token refreshed successfully');
      }).catchError((error) {
        debugPrint('Token refresh failed: $error');
      });
    });
  }

  void destinationSelected(int index) {
    if (index == 1) {
      ref.read(storescreenProvider).clearFilter();
    }
    setState(() {
      currentPageIndex = index;
    });
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
              onDestinationSelected: destinationSelected,
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
        const StoresWidget(),
        const NotificationScreen(),
        DealAlertsScreen(),
        MoreScreen()
      ][currentPageIndex]),
    );
  }
}

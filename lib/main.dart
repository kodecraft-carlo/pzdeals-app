import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pzdeals/firebase_options.dart';
import 'package:pzdeals/src/common_widgets/screen_collections_display.dart';
import 'package:pzdeals/src/features/account/models/settings_data.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/deals/models/index.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_keyword_deals.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/screen_percentage_deals.dart';
import 'package:pzdeals/src/features/more/models/blogs_data.dart';
import 'package:pzdeals/src/features/navigationwidget.dart';
import 'package:pzdeals/src/features/notifications/notifications.dart';
import 'package:pzdeals/src/features/deals/deals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/models/index.dart';
import 'package:pzdeals/src/services/firebase_messaging.dart';
import 'package:pzdeals/src/services/notifications_service.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';
import 'package:pzdeals/src/state/bookmarks_provider.dart';
import 'package:pzdeals/src/utils/data_mapper/index.dart';

final navigatorKey = GlobalKey<NavigatorState>();

NotificationService notifService = NotificationService();
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('notification data: ${message.toMap()}');
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
  Hive.registerAdapter(KeywordDataAdapter());
  Hive.registerAdapter(SettingsDataAdapter());
  runApp(const ProviderScope(child: MainApp()));
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

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});
  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends ConsumerState<MainApp>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    handleDynamicLinks();
  }

  Future<void> handleDynamicLinks() async {
    debugPrint('handleDynamicLinks');
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    handleLinkData(data);
    FirebaseDynamicLinks.instance.onLink.listen(
      (pendingDynamicLinkData) {
        debugPrint('listening to dynamic links');
        if (pendingDynamicLinkData != null) {
          handleLinkData(pendingDynamicLinkData);
        }
      },
    ).onError((error) {
      debugPrint('error listening to dynamic links: $error');
    });
  }

  void handleLinkData(PendingDynamicLinkData? data) {
    final Uri? deepLink = data?.link;
    debugPrint('deepLink: $deepLink');
    if (deepLink != null) {
      // check if path is /deals
      if (deepLink.path == '/deals') {
        // get the value of id query parameter
        final String? id = deepLink.queryParameters['id'];
        debugPrint('deeplink product id: $id');
        navigatorKey.currentState!.pushReplacementNamed('/deals',
            arguments: {'product_id': id ?? ''});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldKey,
      navigatorKey: navigatorKey,
      routes: {
        '/keyword-deals': (context) => const KeywordDealsScreen(),
        '/percentage-deals': (context) => const PercentageDealsScreen(),
        '/notification-screen': (context) => const NotificationScreen(),
        '/deals': (context) => const NavigationWidget(),
        '/deal-collections': (context) => const CollectionDisplayScreenWidget(
              collectionTitle: '',
              collectionId: 0,
            ),
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

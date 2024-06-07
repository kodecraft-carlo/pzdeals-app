import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/list_tile_switch.dart';
import 'package:pzdeals/src/features/alerts/state/categorynotif_provider.dart';
import 'package:pzdeals/src/features/authentication/presentation/widgets/dialog_login_required.dart';
import 'package:pzdeals/src/state/auth_user_data.dart';

class CategoryNotificationToggleList extends ConsumerStatefulWidget {
  const CategoryNotificationToggleList({
    super.key,
  });

  @override
  CategoryNotificationToggleListState createState() =>
      CategoryNotificationToggleListState();
}

class CategoryNotificationToggleListState
    extends ConsumerState<CategoryNotificationToggleList> {
  late List<bool> isSubscribedList;

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(categorySettingsProvider).loadUserSettings();
    });
  }

  void onSwitchChanged(bool value, String title, int index, String keyword) {
    if (ref.read(authUserDataProvider).userData == null) {
      debugPrint('User not authenticated');
      showDialog(
        context: context,
        useRootNavigator: false,
        barrierDismissible: true,
        builder: (context) => ScaffoldMessenger(
          child: Builder(
            builder: (context) => Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: GestureDetector(
                  onTap: () {},
                  child: const LoginRequiredDialog(),
                ),
              ),
            ),
          ),
        ),
      );
      return;
    }
    ref
        .read(categorySettingsProvider)
        .updateSettingsLocally(value, title, keyword);
  }

  String getKeywordTitle(String title) {
    if (title.toLowerCase() == 'toys') {
      return 'Toy Deals';
    }
    return '$title Deals';
  }

  @override
  Widget build(BuildContext context) {
    final categSettingsCollection =
        ref.watch(categorySettingsProvider).collections;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      key: const PageStorageKey<String>('category_notification_toggle_list'),
      shrinkWrap: true,
      itemCount: categSettingsCollection.length,
      itemBuilder: (context, index) {
        final collection = categSettingsCollection[index];
        return Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
          child: ListTileWithSwitchWidget(
            title: getKeywordTitle(collection.title),
            value: collection.isSubscribed,
            onChanged: (value) {
              onSwitchChanged(
                  value, collection.title, index, collection.keyword ?? '');
            },
          ),
        );
      },
    );
  }
}

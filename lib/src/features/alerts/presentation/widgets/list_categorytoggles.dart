import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/list_tile_switch.dart';
import 'package:pzdeals/src/features/alerts/state/categorynotif_provider.dart';
import 'package:pzdeals/src/features/deals/models/collection_data.dart';

class CategoryNotificationToggleList extends ConsumerStatefulWidget {
  const CategoryNotificationToggleList({
    super.key,
  });

  @override
  _CategoryNotificationToggleListState createState() =>
      _CategoryNotificationToggleListState();
}

class _CategoryNotificationToggleListState
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
    ref
        .read(categorySettingsProvider)
        .updateSettingsLocally(value, title, keyword);
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
          return ListTileWithSwitchWidget(
            title: collection.title,
            value: collection.isSubscribed,
            onChanged: (value) {
              onSwitchChanged(
                  value, collection.title, index, collection.keyword ?? '');
            },
          );
        });
  }
}

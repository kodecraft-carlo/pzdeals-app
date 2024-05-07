import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/list_tile_switch.dart';
import 'package:pzdeals/src/features/alerts/state/categorynotif_provider.dart';
import 'package:pzdeals/src/features/deals/models/collection_data.dart';

class CategoryNotificationToggleList extends ConsumerStatefulWidget {
  const CategoryNotificationToggleList({
    super.key,
    required this.collections,
  });

  final List<CollectionData> collections;

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
    isSubscribedList = List.filled(widget.collections.length, false);
    for (int i = 0; i < widget.collections.length; i++) {
      final collection = widget.collections[i];
      final isSubscribed = ref
          .read(categorySettingsProvider)
          .isSubscribed(collection.keyword ?? '');
      isSubscribedList[i] = isSubscribed;
    }
  }

  void onSwitchChanged(bool value, String title, int index, String keyword) {
    // Update the configuration based on the switch state
    // Call the provider to update the settings
    setState(() {
      isSubscribedList[index] = value;
    });
    ref
        .read(categorySettingsProvider)
        .updateSettingsLocally(value, title, keyword);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        key: const PageStorageKey<String>('category_notification_toggle_list'),
        shrinkWrap: true,
        itemCount: widget.collections.length,
        itemBuilder: (context, index) {
          final collection = widget.collections[index];
          return ListTileWithSwitchWidget(
            title: collection.title,
            value: isSubscribedList[index],
            onChanged: (value) {
              onSwitchChanged(
                  value, collection.title, index, collection.keyword ?? '');
            },
          );
        });
  }
}

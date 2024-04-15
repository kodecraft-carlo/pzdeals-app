import 'package:flutter/material.dart';
import 'package:pzdeals/src/common_widgets/list_tile_switch.dart';
import 'package:pzdeals/src/features/deals/models/collection_data.dart';

class CategoryNotificationToggleList extends StatefulWidget {
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
    extends State<CategoryNotificationToggleList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      final collection = widget.collections[index];
      return ListTileWithSwitchWidget(
        title: collection.title,
        value: true,
        onChanged: (value) {
          setState(() {
            // collection.isSubscribed = value;
          });
        },
      );
    });
  }
}

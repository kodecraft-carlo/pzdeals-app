import 'package:pzdeals/src/features/stores/models/store_collection_list.dart';

class StoreDealsCollection {
  final String collectionName;
  final List<StoreCollectionList> collectionList;

  StoreDealsCollection({
    required this.collectionName,
    required this.collectionList,
  });
}

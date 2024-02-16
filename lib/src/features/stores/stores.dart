import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/common_widgets/appbar_icon.dart';
import 'package:pzdeals/src/common_widgets/search_field.dart';
import 'package:pzdeals/src/common_widgets/sliver_appbar.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/account/account.dart';
import 'package:pzdeals/src/features/stores/models/store_data.dart';
import 'package:pzdeals/src/features/stores/presentation/screens/stores_display.dart';
import 'package:pzdeals/src/features/stores/presentation/widgets/store_search_field.dart';

class StoresWidget extends StatefulWidget {
  final List<StoreData> stores = [
    StoreData(
        storeName: 'Amazon',
        storeAssetImage:
            'https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/4b/ed/b0/4bedb06e-f2ba-df92-4a4b-a281ef74dd8c/AppIcon-0-0-1x_U007emarketing-0-6-0-0-85-220.png/350x350.png',
        assetSourceType: 'network'),
    StoreData(
        storeName: 'Walmart',
        storeAssetImage:
            'https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/f7/e5/f7/f7e5f70d-fff5-0efc-ba46-79534a6fb77b/AppIcon-1x_U007emarketing-0-10-0-85-220.png/350x350.png',
        assetSourceType: 'network'),
    StoreData(
        storeName: 'eBay',
        storeAssetImage:
            'https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/22/9f/1b/229f1ba5-8f3d-3f55-047a-af94de4ba2fe/AppIcon-1x_U007emarketing-0-5-0-85-220.png/350x350.png',
        assetSourceType: 'network'),
    StoreData(
        storeName: 'BestBuy',
        storeAssetImage:
            'https://logodownload.org/wp-content/uploads/2020/05/best-buy-logo.png',
        assetSourceType: 'network'),
    StoreData(
        storeName: 'Macy\'s',
        storeAssetImage:
            'https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/42/2a/42/422a428d-7c5e-e64a-0356-e0e6caaa7399/AppIcon-0-0-1x_U007emarketing-0-3-0-0-85-220.png/350x350.png',
        assetSourceType: 'network'),
    StoreData(
        storeName: 'Newegg',
        storeAssetImage:
            'https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/f4/26/90/f42690c6-10df-9f85-ed10-cc5ee84000e1/AppIcon-0-0-1x_U007emarketing-0-7-0-85-220.png/350x350.png',
        assetSourceType: 'network'),
    StoreData(
        storeName: 'Hollister',
        storeAssetImage:
            'https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/36/78/a9/3678a97f-6dfb-e8ea-27c3-7d732403091e/AppIcon-0-0-1x_U007ephone-0-0-85-220.png/350x350.png?',
        assetSourceType: 'network')
  ];
  StoresWidget({super.key});

  @override
  _StoresWidgetState createState() => _StoresWidgetState();
}

class _StoresWidgetState extends State<StoresWidget> {
  late List<StoreData> filteredStores;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    filteredStores = [];
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterStores(String query) {
    setState(() {
      filteredStores = widget.stores
          .where((store) =>
              store.storeName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBarWidget(
              innerBoxIsScrolled: innerBoxIsScrolled,
              searchFieldWidget: StoreSearchFieldWidget(
                hintText: "Search store",
                searchController: searchController,
                filterStores: filterStores,
              )),
        ];
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DisplayStores(
                storedata:
                    filteredStores.isNotEmpty ? filteredStores : widget.stores),
          ),
        ],
      ),
    ));
  }
}

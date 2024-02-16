import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pzdeals/src/common_widgets/screen_login_required.dart';
import 'package:pzdeals/src/features/alerts/models/index.dart';
import 'package:pzdeals/src/features/alerts/presentation/screens/screen_alerts_management.dart';
import 'package:pzdeals/src/state/authentication_provider.dart';

class DealAlertsScreen extends StatelessWidget {
  DealAlertsScreen({super.key});

  final List<String> savedKeywords = [
    'Airpods',
    'iPhone',
    'Nike Panda',
    'Apple Watch series 9',
    'New Balance 550',
    'Veja CWL V-10',
    'JBL Speaker',
  ];

  final List<PopularKeywordData> popularKeywords = [
    PopularKeywordData(
        keyword: 'iPad',
        image:
            'https://crdms.images.consumerreports.org/prod/products/cr/models/405971-9-inch-screen-and-larger-tablets-apple-ipad-air-64gb-2022-10027817.png'),
    PopularKeywordData(
        keyword: 'Pixel',
        image:
            'https://assets3.cbsnewsstatic.com/hub/i/r/2022/07/28/c18428c1-e57d-4ba5-838a-1b47b07fbe03/thumbnail/640x640/587c33fddcd97e0a76845cac117405a8/google-pixel-6a.png'),
    PopularKeywordData(
        keyword: 'Playstation',
        image: 'https://pngimg.com/d/sony_playstation_PNG17539.png'),
    PopularKeywordData(
        keyword: 'Jordans',
        image:
            'https://i.pinimg.com/736x/a2/1c/12/a21c12f3305770c0022e4581d1e36370.jpg'),
    PopularKeywordData(
        keyword: 'Macbook',
        image:
            'https://file.hstatic.net/1000361133/file/macbook-pro-2020_71b9a530f7ac4601a3a7658f3d9e8667.png'),
    PopularKeywordData(
        keyword: 'Crocs',
        image: 'https://pngimg.com/uploads/crocs/crocs_PNG15.png'),
    PopularKeywordData(
        keyword: 'Rayban',
        image:
            'https://clipart-library.com/new_gallery/50-506388_ray-ban-glasses-png-ray-ban-4195-601.png'),
    PopularKeywordData(
        keyword: 'Lego',
        image:
            'https://mightybaby.ph/cdn/shop/products/2_bcac109f-ba61-4d51-b022-4a6f22a29a6a.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final authentication = ref.watch(authenticationProvider);
      return authentication == true
          ? AlertsManagementScreen(
              savedKeywords: savedKeywords,
              popularKeywords: popularKeywords,
            )
          : const LoginRequiredScreen(
              hasCloseButton: false,
            );
    });
  }
}

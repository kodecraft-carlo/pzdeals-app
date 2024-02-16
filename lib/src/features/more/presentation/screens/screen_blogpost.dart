import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pzdeals/src/constants/index.dart';

class BlogpostScreenWidget extends StatelessWidget {
  const BlogpostScreenWidget(
      {super.key, required this.title, required this.imageAsset});

  final String title;
  final String imageAsset;
  final String blogBody =
      '<p>Whether you follow football or you are just here for the snacks, chances are you might be having family and friends over to watch the game on Sunday, February 11.<br></p><p> </p><p>Set up the table, get some delicious snacks and munchies, and don\'t forget the extra seating space. </p><p> </p><p>Don\'t forget to join the<a href="https://twitter.com/NachumSegalNet/status/1753939044226961722">OU\'s Halftime For Torah</a>Show this year! </p><p> </p><style type="text/css" data-mce-fragment="1">td{border:1px solid #ccc}br{mso-data-placement:same-cell}</style><p><a href="https://pzdls.co/3HPOy5p" data-mce-href="https://pzdls.co/3HPOy5p"><strong>1. Dress Up The Table With Football Themed Paper Goods</strong></a></p><p> </p><p>Nothing says<a href="https://pzdls.co/3HPOy5p" data-mce-href="https://pzdls.co/3HPOy5p">Super Bowl</a>like these football cups, plates, and napkins. It makes for a fun vibe while being amazingly convenient for clean up.</p><p> </p><p><a href="https://pzdls.co/3HPOy5p" data-mce-href="https://pzdls.co/3HPOy5p"><span data-sheets-userformat=\'{"2":513,"3":{"1":0},"12":0}\' data-sheets-value=\'{"1":2,"2":"1. Dress Up The Table With Football Themed Paper Goods"}\' data-sheets-root="1" data-mce-fragment="1"><img style="display:block;margin-left:auto;margin-right:auto" alt="" src="https://cdn.shopify.com/s/files/1/1504/4320/files/1_5_480x480.png?v=1707245129" data-mce-style="display: block; margin-left: auto; margin-right: auto;" data-mce-src="https://cdn.shopify.com/s/files/1/1504/4320/files/1_5_480x480.png?v=1707245129"></span></a></p><p> </p><p> </p><p> </p><style type="text/css">td{border:1px solid #ccc}br{mso-data-placement:same-cell}</style><p><strong><a href="https://pzdls.co/3HPOylV" data-mce-href="https://pzdls.co/3HPOylV">2. Or Use This Tablecloth Roll Available In Any Color For Instant Clean Up</a></strong></p><p> </p><p><strong></strong>A<a href="https://pzdls.co/3HPOylV" data-mce-href="https://pzdls.co/3HPOylV">Disposable Tablecloth Roll</a>that you can cut to any length and in any color that you need! Great for parties, mealtime and beyond.</p><p> </p><p><a href="https://pzdls.co/3HPOylV" data-mce-href="https://pzdls.co/3HPOylV"><span data-sheets-root="1" data-sheets-value=\'{"1":2,"2":"2. Use This Tablecloth Roll For Instant Clean Up"}\' data-sheets-userformat=\'{"2":513,"3":{"1":0},"12":0}\'><img src="https://cdn.shopify.com/s/files/1/1504/4320/files/2_5_480x480.png?v=1707245218" alt="" style="display:block;margin-left:auto;margin-right:auto" data-mce-src="https://cdn.shopify.com/s/files/1/1504/4320/files/2_5_480x480.png?v=1707245218" data-mce-style="display: block; margin-left: auto; margin-right: auto;"></span></a></p><p> </p><p> </p><p> </p><style type="text/css">td{border:1px solid #ccc}br{mso-data-placement:same-cell}</style><p><strong><a href="https://pzdls.co/3uqtgbr" data-mce-href="https://pzdls.co/3uqtgbr">3. Make Your Favorite Mixed Drink And Serve It Up In These Pretty Dispensers</a></strong></p><p> </p><p>Alcohol or mocktail, you choose! Mix your favorite drinks in these<a href="https://pzdls.co/3uqtgbr" data-mce-href="https://pzdls.co/3uqtgbr">Cute Dispensers,</a>write a cute name on the provided chalkboard, fill with ice and voila, you got yourself a party.</p><p> </p><p><a href="https://pzdls.co/3uqtgbr" data-mce-href="https://pzdls.co/3uqtgbr"><strong><img src="https://cdn.shopify.com/s/files/1/1504/4320/files/3_5_480x480.png?v=1707245307" alt="" style="display:block;margin-left:auto;margin-right:auto" data-mce-src="https://cdn.shopify.com/s/files/1/1504/4320/files/3_5_480x480.png?v=1707245307" data-mce-style="display: block; margin-left: auto; margin-right: auto;"></strong></a></p><p> </p><p> </p><p> </p><style type="text/css">td{border:1px solid #ccc}br{mso-data-placement:same-cell}</style><p><a href="https://pzdls.co/3HPRbUY" data-mce-href="https://pzdls.co/3HPRbUY"><strong>4. This Food Stadium Will Be The Centerpiece That Will Impress</strong></a></p><p> </p><p><strong></strong>Oh so fun! Fill the<a href="https://pzdls.co/3HPRbUY" data-mce-href="https://pzdls.co/3HPRbUY">Stadium Bleachers</a>with all your favorite game day foods. You can even have opposing teams like Team Hotdog And Team Burger. Just for funsies.</p><p> </p><p><a href="https://pzdls.co/3HPRbUY" data-mce-href="https://pzdls.co/3HPRbUY"><strong><img style="display:block;margin-left:auto;margin-right:auto" src="https://cdn.shopify.com/s/files/1/1504/4320/files/4_7_480x480.png?v=1707245366" alt="" data-mce-style="display: block; margin-left: auto; margin-right: auto;" data-mce-src="https://cdn.shopify.com/s/files/1/1504/4320/files/4_7_480x480.png?v=1707245366"></strong></a></p><p> </p><p> </p><p> </p><style type="text/css">td{border:1px solid #ccc}br{mso-data-placement:same-cell}</style><p><a href="https://pzdls.co/3HRlIl2" data-mce-href="https://pzdls.co/3HRlIl2"><strong>5. An Instant Couch For When You Need Extra Comfy Seating</strong></a></p><p> </p><p>We\'re only half-joking on this one. This "<a href="https://pzdls.co/3HRlIl2" data-mce-href="https://pzdls.co/3HRlIl2">Couch</a>" slash blow-up pillow fills up in seconds when you hold open the mouth and catch some air. Clip the straps and you have yourself a comfy place for game viewing! Bonus: It folds up super tiny for you to be able to take anywhere (think park/beach) and to store away easily.</p><p> </p><p><a href="https://pzdls.co/3HRlIl2" data-mce-href="https://pzdls.co/3HRlIl2"><strong><img style="display:block;margin-left:auto;margin-right:auto" alt="" src="https://cdn.shopify.com/s/files/1/1504/4320/files/5_7_480x480.png?v=1707245481" data-mce-style="display: block; margin-left: auto; margin-right: auto;" data-mce-src="https://cdn.shopify.com/s/files/1/1504/4320/files/5_7_480x480.png?v=1707245481"></strong></a></p><p> </p><p> </p><p> </p><style type="text/css">td{border:1px solid #ccc}br{mso-data-placement:same-cell}</style><p><a href="https://pzdls.co/3HNE4DC" data-mce-href="https://pzdls.co/3HNE4DC"><strong>6. Or Blow Up This Inflatable Arm Chair That Stores Away When Not In Use</strong></a></p><p> </p><p>This<a href="https://pzdls.co/3HNE4DC" data-mce-href="https://pzdls.co/3HNE4DC">Arm-Chair</a>blows up in minutes with a pump. And no armchair is complete without a beverage holder! Done and done.</p><p> </p><p><a href="https://pzdls.co/3HNE4DC" data-mce-href="https://pzdls.co/3HNE4DC"><strong><img style="display:block;margin-left:auto;margin-right:auto" alt="" src="https://cdn.shopify.com/s/files/1/1504/4320/files/7_7_480x480.png?v=1707245559" data-mce-style="display: block; margin-left: auto; margin-right: auto;" data-mce-src="https://cdn.shopify.com/s/files/1/1504/4320/files/7_7_480x480.png?v=1707245559"></strong></a></p><p> </p><p> </p><p> </p><style type="text/css">td{border:1px solid #ccc}br{mso-data-placement:same-cell}</style><p><a href="https://pzdls.co/3HLJeA6" data-mce-href="https://pzdls.co/3HLJeA6"><strong>7. Project From Your Phone Or Other Bluetooth Capabilities To Bring The Game To Life</strong></a></p><p> </p><p>Get a huge version of the game projected on your wall with this tiny but mighty<a href="https://pzdls.co/3HLJeA6" data-mce-href="https://pzdls.co/3HLJeA6">Projector</a>. Connects to your phone so you don\'t need to busy yourself with annoying HDMI cords.</p><p> </p><p><a href="https://pzdls.co/3HLJeA6" data-mce-href="https://pzdls.co/3HLJeA6"><strong><img style="display:block;margin-left:auto;margin-right:auto" alt="" src="https://cdn.shopify.com/s/files/1/1504/4320/files/8_7_480x480.png?v=1707245634" data-mce-style="display: block; margin-left: auto; margin-right: auto;" data-mce-src="https://cdn.shopify.com/s/files/1/1504/4320/files/8_7_480x480.png?v=1707245634"></strong></a></p><p> </p><p> </p><p> </p><style type="text/css">td{border:1px solid #ccc}br{mso-data-placement:same-cell}</style><p><a href="https://pzdls.co/3HN842D" data-mce-href="https://pzdls.co/3HN842D"><strong>8. A Cute And Kitschy Inflatable Cooler For Drinks</strong></a></p><p> </p><p>These<a href="https://pzdls.co/3HN842D" data-mce-href="https://pzdls.co/3HN842D">Inflatable Beverage Holders</a>are so fun and just scream Super Bowl.  </p><p> </p><p><a href="https://pzdls.co/3HN842D"><strong><img alt="" src="https://cdn.shopify.com/s/files/1/1504/4320/files/9_6_480x480.png?v=1707245736" style="display:block;margin-left:auto;margin-right:auto" data-mce-src="https://cdn.shopify.com/s/files/1/1504/4320/files/9_6_480x480.png?v=1707245736" data-mce-style="display: block; margin-left: auto; margin-right: auto;"></strong></a></p><p> </p><p> </p><p> </p><style type="text/css">td{border:1px solid #ccc}br{mso-data-placement:same-cell}</style><p><a href="https://pzdls.co/3unQnDw" data-mce-href="https://pzdls.co/3unQnDw"><strong>9. Or Go For A Classic Vibe With A Metal Tub</strong></a></p><p> </p><p><strong></strong><a href="https://pzdls.co/3unQnDw" data-mce-href="https://pzdls.co/3unQnDw">Galvanized Metal</a>matches any decor, from rustic to high-end. You\'ll be surprised how often you will use these buckets, as an ice cooler or as party table decor. </p><p> </p><p><a href="https://pzdls.co/3unQnDw"><strong><img alt="" src="https://cdn.shopify.com/s/files/1/1504/4320/files/10_6_480x480.png?v=1707245863" style="display:block;margin-left:auto;margin-right:auto" data-mce-src="https://cdn.shopify.com/s/files/1/1504/4320/files/10_6_480x480.png?v=1707245863" data-mce-style="display: block; margin-left: auto; margin-right: auto;"></strong></a></p><p> </p><p> </p><p><a href="https://pzdls.co/3SqWOOh"><strong>10. Make Some DELICIOUS Munchies</strong></a></p><p> </p><p>Like these<a href="https://pzdls.co/3SqWOOh">Cornflake Chicken Poppers</a>, courtesy of Heaven On The Table (Instagram).</p><p> </p><p><a href="https://pzdls.co/3SqWOOh"><strong><img style="display:block;margin-left:auto;margin-right:auto" src="https://cdn.shopify.com/s/files/1/1504/4320/files/heavenontable_480x480.png?v=1707245961" alt="" data-mce-style="display: block; margin-left: auto; margin-right: auto;"></strong></a></p><p> </p><p> </p><p> </p><p><strong><a href="https://pzdls.co/3w8X3Gf" data-mce-href="https://pzdls.co/3w8X3Gf">11. Why Choose? 3 Types Of Wings To Impress</a></strong></p><p> </p><p>Buffalo wings are a classic but who\'s to say no to chili-lime!? Try these Air Fryer version and skip the deep fryer, from<a href="https://pzdls.co/3w8X3Gf">@CooksCountry</a>.</p><p> </p><p><a href="https://pzdls.co/3w8X3Gf" data-mce-href="https://pzdls.co/3w8X3Gf"><img src="https://cdn.shopify.com/s/files/1/1504/4320/files/wings_480x480.png?v=1707248462" alt="" style="display:block;margin-left:auto;margin-right:auto" data-mce-src="https://cdn.shopify.com/s/files/1/1504/4320/files/wings_480x480.png?v=1707248462" data-mce-style="display: block; margin-left: auto; margin-right: auto;"></a></p><p> </p><p> </p><p> </p><p><a href="https://pzdls.co/49o73cU" data-mce-href="https://pzdls.co/49o73cU"><strong>12. These Crazy Pretzel Dog Bites Would Be An Instant Hit</strong></a></p><p> </p><p>Recipe courtesy of @<a href="https://pzdls.co/49o73cU" data-mce-href="https://pzdls.co/49o73cU">Naomi_TGIS</a>, the undisputed Super Bowl queen. Don\'t believe us? Check out her Super Bowl menu highlights<a href="https://www.instagram.com/stories/highlights/17995943401607688/">here</a>.</p><p> </p><p><a href="https://pzdls.co/49o73cU" data-mce-href="https://pzdls.co/49o73cU"><img src="https://cdn.shopify.com/s/files/1/1504/4320/files/pretzeldogs_480x480.png?v=1707326154" alt="" style="display:block;margin-left:auto;margin-right:auto" data-mce-fragment="1" data-mce-src="https://cdn.shopify.com/s/files/1/1504/4320/files/pretzeldogs_480x480.png?v=1707326154" data-mce-style="display: block; margin-left: auto; margin-right: auto;"></a></p><p> </p><p> </p><p>Game on, who are you banking on to take the W?</p><p> </p>';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: PZColors.pzBlack,
            fontWeight: FontWeight.w700,
            fontSize: Sizes.appBarFontSize,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        surfaceTintColor: PZColors.pzWhite,
        backgroundColor: PZColors.pzWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingAllSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              imageAsset,
              width: MediaQuery.of(context).size.width / 2,
              fit: BoxFit.fitWidth,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return SizedBox(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          PZColors.pzOrange),
                      backgroundColor: PZColors.pzLightGrey,
                      strokeWidth: 3,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: Sizes.spaceBetweenContent),
            Text(
              title,
              style: const TextStyle(
                  color: PZColors.pzBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: Sizes.fontSizeLarge),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBetweenSections),
            Html(
              data: blogBody,
            ),
          ],
        ),
      ),
    );
  }
}

String getStoreImageUrlFromTags(List<dynamic> tagIds) {
  final Map<String, String> storeImageUrls = {
    'woot': 'assets/images/stores/woot.png',
    'amazon': 'assets/images/stores/amazon.png',
    'ebay': 'assets/images/stores/ebay.png',
    'bestbuy': 'assets/images/stores/bestbuy.png',
    'walmart': 'assets/images/stores/walmart.png',
    'newegg': 'assets/images/stores/newegg.png',
  };

  for (var tag in tagIds) {
    final tagName = tag['tags_id']['tag_name'].toLowerCase();
    if (storeImageUrls.containsKey(tagName)) {
      return storeImageUrls[tagName] ?? 'assets/images/pzdeals_store.png';
    }
  }
  return 'assets/images/pzdeals_store.png';
}

bool isProductExpired(List<dynamic> tagIds) {
  for (var tag in tagIds) {
    final tagName = tag['tags_id']['tag_name'].toLowerCase();
    if (tagName == 'sold-out' || tagName == 'soldout') {
      return true;
    }
  }
  return false;
}

bool isProductNoPrice(List<dynamic> tagIds) {
  for (var tag in tagIds) {
    final tagName = tag['tags_id']['tag_name'].toLowerCase();
    if (tagName == 'no-price' || tagName == 'noprice') {
      return true;
    }
  }
  return false;
}

bool isProductPriceValid(dynamic productPrice) {
  if (productPrice == null) {
    return false;
  }
  if (productPrice is String) {
    return double.tryParse(productPrice) != null;
  }
  return productPrice is num;
}

String extractTagDealDescription(List<dynamic> tagIds) {
  String tagDealDescription = '';
  for (var tag in tagIds) {
    final tagName = tag['tags_id']['tag_name'].toLowerCase();
    switch (tagName) {
      case 'walmart':
        tagDealDescription +=
            '<li>Get free shipping on orders of \$35 or more, or with a <strong><a href="https://fave.co/3n9Mutc" target="_blank">Walmart+</a></strong> subscription.</li>';
      case 'sold-out':
        tagDealDescription +=
            '<li><p>Join our <strong><a href="https://chat.whatsapp.com/FB2m2wn2Eed8X7U1dKvuJQ">WhatsApp</a></strong> or <strong><a href="https://twitter.com/pzdeals">Twitter</a></strong> to be notified when it\'s back!</p></li>';
      case 'ac':
        tagDealDescription +=
            '<li class="nudge2">Make sure to <span style="font-weight: 600; color:green">clip the coupon</span> from under the price on Amazon.</li>';
      case 'ssc':
        tagDealDescription +=
            '<li>Pay only <strong>\$X.XX</strong> when you <span style="font-weight: 600; color:green">clip the coupon</span> from under the price on Amazon and checkout with <span style="font-weight: 600; color:green">Subscribe &amp; Save!</span> You may cancel Subscribe &amp; Save at any time after your order ships.</li>';
      case 'ss':
        tagDealDescription +=
            '<li>Pay only <strong>\$X.XX</strong> when you checkout with <span style="font-weight: 600; color:green">Subscribe &amp; Save!</span> You may cancel Subscribe &amp; Save at any time after your order ships.</li>';
      case 'today':
        tagDealDescription +=
            '<li>Sale ends 11:59pm PT or while supplies last.</li>';
      case 'drop':
        tagDealDescription +=
            '<li><strong>Simply add the item to your cart and the price will drop in your cart at checkout.</strong></li>';
      case 'oos':
        tagDealDescription +=
            '<li>Even it says it\'s <strong><span style="color: #ff2a00;">temporarily out of stock,</span></strong> you can still order it now to lock in this price.</li>';
      case 'lightning':
        tagDealDescription +=
            '<li><span style="color: #ff2a00;"><strong>UPDATE:</strong></span> This lightning deal is now 100% claimed. Click <strong>join waitlist</strong> and Amazon will notify you when it becomes available again.</li>';
    }
  }
  return tagDealDescription != '' ? '<ul>$tagDealDescription</ul>' : '';
}

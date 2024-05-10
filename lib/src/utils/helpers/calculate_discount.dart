int calculateDiscountPercentage(dynamic oldPrice, dynamic price) {
  if (oldPrice is String) {
    oldPrice = double.parse(oldPrice);
  }
  if (price is String) {
    price = double.parse(price);
  }
  if (oldPrice <= 0 || price <= 0) return 0;
  return ((oldPrice - price) / oldPrice * 100).round();
}

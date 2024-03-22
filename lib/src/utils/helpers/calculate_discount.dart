int calculateDiscountPercentage(double oldPrice, double price) {
  if (oldPrice <= 0 || price <= 0) return 0;
  return ((oldPrice - price) / oldPrice * 100).toInt();
}

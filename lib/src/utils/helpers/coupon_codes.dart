List<String> getCouponCodesFromString(String sku) {
  return sku.split(',').map((e) => e.trim()).toList();
}

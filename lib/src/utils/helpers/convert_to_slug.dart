String convertToSlug(String input) {
  String slug = input.replaceAll(' ', '-');
  slug = slug.replaceAll('&', '');
  slug = slug.replaceAll("'", '');
  slug = slug.replaceAll(":", '');
  slug = slug.replaceAll(".", '-');
  slug = slug.replaceAll("(", '');
  slug = slug.replaceAll(")", '');
  slug = slug.replaceAll(",", '');
  slug = slug.replaceAll("%", '');
  slug = slug.replaceAll("--", '-');
  slug = slug.toLowerCase();
  return slug;
}

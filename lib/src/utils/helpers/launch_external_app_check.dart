bool isLaunchExternalApp(String value) {
  if (value.isEmpty) {
    return false;
  }
  if (value.toLowerCase() == 'amazon' ||
      value.toLowerCase() == 'walmart' ||
      value.toLowerCase().contains('https://www.amazon.com') ||
      value.toLowerCase().contains('https://www.walmart.com') ||
      value.toLowerCase().contains('https://goto.walmart.com')) {
    return true;
  }
  return false;
}

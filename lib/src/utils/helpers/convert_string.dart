//convert & to url encoded
String urlEncodeAmpersand(String url) {
  return url.replaceAll('&', '%26');
}

String formatTagNameToCapitalizedWord(String tagName) {
  // Split the string by hyphens and spaces, then map over each word to capitalize the first letter
  var formatted = tagName.split(RegExp('[- ]')).map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  }).join(' '); // Join the words back with spaces

  return formatted;
}

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

String capitalizeFirstLetter(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}

//remove all html tags, replace <p> with - and remove all other tags
String removeHtmlTags(String htmlString) {
  final htmlString0 = htmlString
      .replaceAll(RegExp(r'<p>'), ' - ')
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll(RegExp(r'&nbsp;'), ' ')
      .replaceAll(RegExp(r'&amp;'), '&')
      .replaceAll(RegExp(r'&quot;'), '"')
      .replaceAll(RegExp(r'&lt;'), '<')
      .replaceAll(RegExp(r'&gt;'), '>');

  //check first character if it is a space or a dash
  if (htmlString0[0] == ' ' || htmlString0[0] == '-') {
    return htmlString0.substring(3);
  }
  return htmlString0;
}

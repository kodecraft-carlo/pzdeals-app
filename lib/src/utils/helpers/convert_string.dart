//convert & to url encoded
String urlEncodeAmpersand(String url) {
  return url.replaceAll('&', '%26');
}

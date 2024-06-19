bool isEmailAddressValid(String email) {
  String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  RegExp regExp = RegExp(emailPattern);
  return regExp.hasMatch(email);
}

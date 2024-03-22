String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please provide an email address';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }
  return null;
}

final RegExp _nameRegExp = RegExp(r"^[\p{L} ,.'-]*$",
    caseSensitive: false, unicode: true, dotAll: true);

String? firstnameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please provide your first name';
  }
  if (!_nameRegExp.hasMatch(value)) {
    return 'Please provide a valid first name';
  }
  return null;
}

String? middleNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please provide your middle name';
  }
  if (!_nameRegExp.hasMatch(value)) {
    return 'Please provide a valid middle name';
  }
  return null;
}

String? lastNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please provide your last name';
  }
  if (!_nameRegExp.hasMatch(value)) {
    return 'Please provide a valid last name';
  }
  return null;
}

String? genderValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select your gender';
  }
  return null;
}

String? dateOfBirthValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please provide your date of birth';
  }
  return null;
}

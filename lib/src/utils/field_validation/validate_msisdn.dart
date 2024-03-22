import 'package:intl_phone_field/phone_number.dart';

String? phoneNumberValidator(PhoneNumber? phone) {
  if (phone == null || phone.completeNumber.isEmpty) {
    return 'Please provide your phone number';
  }
  if (!phone.completeNumber.startsWith('+') ||
      phone.completeNumber.length < 12) {
    return 'Please provide a valid phone number';
  }

  return null;
}

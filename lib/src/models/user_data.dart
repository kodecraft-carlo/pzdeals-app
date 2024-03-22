class UserData {
  final String uid;
  final String? emailAddress;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final DateTime? birthDate;
  final String? gender;
  final DateTime? dateRegistered;

  UserData(
      {this.dateRegistered,
      this.emailAddress,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.birthDate,
      this.gender,
      required this.uid});
}

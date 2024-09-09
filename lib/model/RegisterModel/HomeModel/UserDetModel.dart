class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNumber;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
    );
  }
}

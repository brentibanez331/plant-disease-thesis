class UserModel {
  final int id;
  final String phoneNumber;
  final String email;
  final String firstName;
  final String lastName;
  final String username;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.phoneNumber,
    required this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      username: json['username'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}

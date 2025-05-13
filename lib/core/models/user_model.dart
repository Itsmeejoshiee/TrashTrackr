class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      firstName: data['first_name'],
      lastName: data['last_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}

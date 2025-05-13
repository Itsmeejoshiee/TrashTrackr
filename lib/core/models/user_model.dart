class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String profilePicture;
  final int followerCount;
  final int followingCount;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.followerCount,
    required this.followingCount,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      profilePicture: data['profile_picture'],
      followerCount: data['followers'],
      followingCount: data['following'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePicture,
      'follower_count': followerCount,
      'following_count': followingCount,
    };
  }
}

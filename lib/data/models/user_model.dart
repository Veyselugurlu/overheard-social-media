class UserModel {
  final String uid;
  final String name;
  final String gender;
  final String email;
  final String? profilePhotoUrl;
  final int age;
  final String city;
  final String bdate;
  final int followersCount;
  final int followingCount;
  final List<String> savedPosts;
  final List<String> followers;
  final List<String> following;

  const UserModel({
    required this.uid,
    required this.name,
    required this.gender,
    required this.email,
    required this.age,
    required this.city,
    required this.bdate,
    this.profilePhotoUrl,
    this.followersCount = 0,
    this.followingCount = 0,
    this.savedPosts = const [],
    this.followers = const [],
    this.following = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: (data['uid'] ?? '').toString(),
      name: (data['name'] ?? '').toString(),
      gender: (data['gender'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      profilePhotoUrl: data['profilePhotoUrl'] as String?,
      age: (data['age'] as int?) ?? 0,
      city: (data['city'] ?? '').toString(),
      bdate: (data['bdate'] ?? '').toString(),
      followersCount: (data['followersCount'] as int?) ?? 0,
      followingCount: (data['followingCount'] as int?) ?? 0,
      savedPosts: List<String>.from((data['savedPosts'] as List?) ?? []),
      followers: List<String>.from((data['followers'] as List?) ?? []),
      following: List<String>.from((data['following'] as List?) ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'gender': gender,
      'email': email,
      'age': age,
      'city': city,
      'bdate': bdate,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'followers': followers,
      'following': following,
      'savedPosts': savedPosts,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? gender,
    String? email,
    String? profilePhotoUrl,
    int? age,
    String? city,
    String? bdate,
    int? followersCount,
    int? followingCount,
    List<String>? savedPosts,
    List<String>? followers,
    List<String>? following,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      age: age ?? this.age,
      city: city ?? this.city,
      bdate: bdate ?? this.bdate,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      savedPosts: savedPosts ?? this.savedPosts,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}

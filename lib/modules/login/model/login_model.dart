class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? emailVerifiedAt;
  String? userType;
  String? gender;
  String? playerId;
  String? contactNumber;
  String? uid;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? apiToken;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.emailVerifiedAt,
    this.userType,
    this.gender,
    this.playerId,
    this.contactNumber,
    this.uid,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.profileImage,
    this.apiToken,
  });

  // Factory constructor to create an instance from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    final data = json['data']; // Access the nested "data" object first

    return UserData(
      id: data['id'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      email: data['email'],
      username: data['username'],
      emailVerifiedAt: data['email_verified_at'],
      userType: data['user_type'],
      gender: data['gender'],
      playerId: data['player_id'],
      contactNumber: data['contact_number'],
      uid: data['uid'],
      status: data['status'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
      profileImage: data['profile_image'],
      apiToken: data['api_token'],
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'username': username,
      'email_verified_at': emailVerifiedAt,
      'user_type': userType,
      'gender': gender,
      'player_id': playerId,
      'contact_number': contactNumber,
      'uid': uid,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile_image': profileImage,
      'api_token': apiToken,
    };
  }
}

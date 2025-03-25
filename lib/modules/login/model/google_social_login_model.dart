class SocialLoginResponse {
  final bool status;
  final String message;
  final SocialLoginResponseData data;

  SocialLoginResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    return SocialLoginResponse(
      status: json['status'],
      message: json['message'],
      data: SocialLoginResponseData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class SocialLoginResponseData {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String? emailVerifiedAt;
  final String userType;
  final String? gender;
  final String? playerId;
  final String? contactNumber;
  final String? uid;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String apiToken;
  final String profileImage;
  final List<dynamic> media;

  SocialLoginResponseData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.emailVerifiedAt,
    required this.userType,
    this.gender,
    this.playerId,
    this.contactNumber,
    this.uid,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.apiToken,
    required this.profileImage,
    required this.media,
  });

  factory SocialLoginResponseData.fromJson(Map<String, dynamic> json) {
    return SocialLoginResponseData(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      username: json['username'],
      emailVerifiedAt: json['email_verified_at'],
      userType: json['user_type'],
      gender: json['gender'],
      playerId: json['player_id'],
      contactNumber: json['contact_number'],
      uid: json['uid'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      apiToken: json['api_token'],
      profileImage: json['profile_image'],
      media: List<dynamic>.from(json['media'] ?? []),
    );
  }

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
      'api_token': apiToken,
      'profile_image': profileImage,
      'media': media,
    };
  }
}

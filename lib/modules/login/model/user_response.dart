// class UserResponse {
//   bool status;
//   UserData userData;
//   String message;
//
//   UserResponse({
//     this.status = false,
//     required this.userData,
//     this.message = "",
//   });
//
//   factory UserResponse.fromJson(Map<String, dynamic> json) {
//     return UserResponse(
//       status: json['status'] is bool ? json['status'] : false,
//       userData: json['data'] is Map ? UserData.fromJson(json['data']) : UserData(),
//       message: json['message'] is String ? json['message'] : "",
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'data': userData.toJson(),
//       'message': message,
//     };
//   }
// }
//
// class UserData {
//   int id;
//   String firstName;
//   String lastName;
//   String email;
//   dynamic mobile;
//   String loginType;
//   dynamic gender;
//   dynamic dateOfBirth;
//   dynamic emailVerifiedAt;
//   int status;
//   dynamic lastNotificationSeen;
//   String createdAt;
//   String updatedAt;
//   dynamic deletedAt;
//   String apiToken;
//   String fullName;
//   String profileImage;
//
//   UserData({
//     this.id = -1,
//     this.firstName = "",
//     this.lastName = "",
//     this.email = "",
//     this.mobile,
//     this.loginType = "",
//     this.gender,
//     this.dateOfBirth,
//     this.emailVerifiedAt,
//     this.status = -1,
//     this.lastNotificationSeen,
//     this.createdAt = "",
//     this.updatedAt = "",
//     this.deletedAt,
//     this.apiToken = "",
//     this.fullName = "",
//     this.profileImage = "",
//   });
//
//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       id: json['id'] is int ? json['id'] : -1,
//       firstName: json['first_name'] is String ? json['first_name'] : "",
//       lastName: json['last_name'] is String ? json['last_name'] : "",
//       email: json['email'] is String ? json['email'] : "",
//       mobile: json['mobile'],
//       loginType: json['login_type'] is String ? json['login_type'] : "",
//       gender: json['gender'],
//       dateOfBirth: json['date_of_birth'],
//       emailVerifiedAt: json['email_verified_at'],
//       status: json['status'] is int ? json['status'] : -1,
//       lastNotificationSeen: json['last_notification_seen'],
//       createdAt: json['created_at'] is String ? json['created_at'] : "",
//       updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
//       deletedAt: json['deleted_at'],
//       apiToken: json['api_token'] is String ? json['api_token'] : "",
//       fullName: json['full_name'] is String ? json['full_name'] : "",
//       profileImage: json['profile_image'] is String ? json['profile_image'] : "",
//      );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'first_name': firstName,
//       'last_name': lastName,
//       'email': email,
//       'mobile': mobile,
//       'login_type': loginType,
//       'gender': gender,
//       'date_of_birth': dateOfBirth,
//       'email_verified_at': emailVerifiedAt,
//       'status': status,
//       'last_notification_seen': lastNotificationSeen,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'deleted_at': deletedAt,
//       'api_token': apiToken,
//       'full_name': fullName,
//       'profile_image': profileImage,
//       'media': [],
//     };
//   }
// }
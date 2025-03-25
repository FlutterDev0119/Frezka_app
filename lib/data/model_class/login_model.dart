// class LoginResponse {
//   bool? status;
//   UserData? userData;
//   num? errorCode;
//   String? message;
//
//   LoginResponse({this.status, this.userData, this.errorCode, this.message});
//
//   LoginResponse.fromJson(dynamic json) {
//     status = json['status'];
//     userData = json['data'] != null ? UserData.fromJson(json['data']) : null;
//     errorCode = json['error_code'];
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['status'] = status;
//     if (userData != null) {
//       map['data'] = userData?.toJson();
//     }
//     map['error_code'] = errorCode;
//     map['message'] = message;
//     return map;
//   }
// }
//
// class UserData {
//   num? id;
//   String? username;
//   String? name;
//   String? email;
//   String? contactNumber;
//   String? profileImage;
//   String? gender;
//   String? country;
//   String? activationToken;
//   String? userType;
//   String? apiToken;
//   String? emailVerifiedAt;
//   String? status;
//   String? createdBy;
//   String? linkId;
//   String? banned;
//   String? createdAt;
//   String? updatedAt;
//   String? vehicleBrand;
//   String? vehicleNo;
//   String? agencyName;
//   var isCertified;
//   String? deviceId;
//   var readyness;
//   Agency? agency;
//   int? isCollector;
//   String? zipCodes;
//
//   UserData({
//     this.id,
//     this.username,
//     this.name,
//     this.email,
//     this.contactNumber,
//     this.profileImage,
//     this.gender,
//     this.country,
//     this.activationToken,
//     this.userType,
//     this.apiToken,
//     this.emailVerifiedAt,
//     this.status,
//     this.createdBy,
//     this.linkId,
//     this.banned,
//     this.createdAt,
//     this.updatedAt,
//     this.vehicleBrand,
//     this.vehicleNo,
//     this.agencyName,
//     this.isCertified,
//     this.deviceId,
//     this.readyness,
//     this.agency,
//     this.isCollector,
//   });
//
//   UserData.fromJson(dynamic json) {
//     id = json['id'];
//     zipCodes = username = json['username'];
//     name = json['name'];
//     email = json['email'];
//     contactNumber = json['contact_number'];
//     profileImage = json['profile_image'];
//     gender = json['gender'];
//     country = json['country'];
//     activationToken = json['activation_token'];
//     userType = json['user_type'];
//     apiToken = json['api_token'];
//     emailVerifiedAt = json['email_verified_at'];
//     status = json['status'];
//     createdBy = json['created_by'];
//     linkId = json['link_id'];
//     banned = json['banned'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     vehicleBrand = json['vehicle_brand'];
//     vehicleNo = json['vehicle_no'];
//     agencyName = json['agency_name'];
//     isCertified = json['is_certified'];
//     deviceId = json['device_id'];
//     readyness = json['readyness'];
//     agency = json['agency'] != null ? Agency.fromJson(json['agency']) : null;
//     isCollector = json['is_collector'];
//     zipCodes = json['zipcodes'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['username'] = username;
//     map['name'] = name;
//     map['email'] = email;
//     map['contact_number'] = contactNumber;
//     map['profile_image'] = profileImage;
//     map['gender'] = gender;
//     map['country'] = country;
//     map['activation_token'] = activationToken;
//     map['user_type'] = userType;
//     map['api_token'] = apiToken;
//     map['email_verified_at'] = emailVerifiedAt;
//     map['status'] = status;
//     map['created_by'] = createdBy;
//     map['link_id'] = linkId;
//     map['banned'] = banned;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     map['vehicle_brand'] = vehicleBrand;
//     map['vehicle_no'] = vehicleNo;
//     map['agency_name'] = agencyName;
//     map['is_certified'] = isCertified;
//     map['device_id'] = deviceId;
//     map['readyness'] = readyness;
//     if (agency != null) {
//       map['agency'] = agency?.toJson();
//     }
//     map['is_collector'] = isCollector;
//     map['zipcodes'] = zipCodes;
//
//     return map;
//   }
// }
//
// class Agency {
//   num? agencyId;
//   String? name;
//   String? contactName;
//   String? email;
//   String? contactNumber;
//   String? mobileNumber;
//   String? address;
//   String? zipcode;
//   String? country;
//   String? state;
//   String? city;
//   String? taxId;
//   String? taxRegistrationOffice;
//   String? status;
//   String? expireLicenceDate;
//   String? agencyLicence;
//   String? logo;
//   String? createdAt;
//   String? updatedAt;
//   String? lat;
//   String? long;
//   String? balance;
//
//   Agency({
//     this.agencyId,
//     this.name,
//     this.contactName,
//     this.email,
//     this.contactNumber,
//     this.mobileNumber,
//     this.address,
//     this.zipcode,
//     this.country,
//     this.state,
//     this.city,
//     this.taxId,
//     this.taxRegistrationOffice,
//     this.status,
//     this.expireLicenceDate,
//     this.agencyLicence,
//     this.logo,
//     this.createdAt,
//     this.updatedAt,
//     this.lat,
//     this.long,
//     this.balance,
//   });
//
//   Agency.fromJson(dynamic json) {
//     agencyId = json['agency_id'];
//     name = json['name'];
//     contactName = json['contact_name'];
//     email = json['email'];
//     contactNumber = json['contact_number'];
//     mobileNumber = json['mobile_number'];
//     address = json['address'];
//     zipcode = json['zipcode'];
//     country = json['country'];
//     state = json['state'];
//     city = json['city'];
//     taxId = json['tax_id'];
//     taxRegistrationOffice = json['tax_registration_office'];
//     status = json['status'];
//     expireLicenceDate = json['expire_licence_date'];
//     agencyLicence = json['agency_licence'];
//     logo = json['logo'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     lat = json['lat'];
//     long = json['long'];
//     balance = json['balance'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['agency_id'] = agencyId;
//     map['name'] = name;
//     map['contact_name'] = contactName;
//     map['email'] = email;
//     map['contact_number'] = contactNumber;
//     map['mobile_number'] = mobileNumber;
//     map['address'] = address;
//     map['zipcode'] = zipcode;
//     map['country'] = country;
//     map['state'] = state;
//     map['city'] = city;
//     map['tax_id'] = taxId;
//     map['tax_registration_office'] = taxRegistrationOffice;
//     map['status'] = status;
//     map['expire_licence_date'] = expireLicenceDate;
//     map['agency_licence'] = agencyLicence;
//     map['logo'] = logo;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     map['lat'] = lat;
//     map['long'] = long;
//     map['balance'] = balance;
//     return map;
//   }
// }

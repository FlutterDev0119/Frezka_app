class OtpResponse {
  String? message;

  OtpResponse({this.message});

  // Factory constructor to create an instance from JSON
  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      message: json['message'],
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

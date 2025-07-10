class UserProfileModel {
  String fullName;
  String email;
  String mobile;
  String password;
  String confirmPassword;
  DateTime? dob;
  String gender;
  String country;
  String state;
  String city;
  String pin;
  String qualification;
  String customQualification;
  String occupation;
  String referral;
  List<String> selectedInterests;

  UserProfileModel({
    this.fullName = '',
    this.email = '',
    this.mobile = '',
    this.password = '',
    this.confirmPassword = '',
    this.dob,
    this.gender = '',
    this.country = '',
    this.state = '',
    this.city = '',
    this.pin = '',
    this.qualification = '',
    this.customQualification = '',
    this.occupation = '',
    this.referral = '',
    this.selectedInterests = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'mobile': mobile,
      'password': password,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'country': country,
      'state': state,
      'city': city,
      'pin': pin,
      'qualification': qualification == 'others' ? customQualification : qualification,
      'occupation': occupation,
      'referral': referral,
      'selectedInterests': selectedInterests,
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      password: json['password'] ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      gender: json['gender'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pin: json['pin'] ?? '',
      qualification: json['qualification'] ?? '',
      occupation: json['occupation'] ?? '',
      referral: json['referral'] ?? '',
      selectedInterests: List<String>.from(json['selectedInterests'] ?? []),
    );
  }
}

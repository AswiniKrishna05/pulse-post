class PersonalInfoModel {
  final String fullName;
  final String email;
  final String mobile;
  final String password;
  final DateTime dob;
  final int age;
  final String gender;
  final String country;
  final String state;
  final String city;
  final String pinCode;
  final String qualification;
  final String occupation;
  final List<String> interests;
  final String? profileImageUrl;
  final String? referral;

  PersonalInfoModel({
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.password,
    required this.dob,
    required this.age,
    required this.gender,
    required this.country,
    required this.state,
    required this.city,
    required this.pinCode,
    required this.qualification,
    required this.occupation,
    required this.interests,
    this.profileImageUrl,
    this.referral,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'mobile': mobile,
      'password': password,
      'dob': dob.toIso8601String(),
      'age': age,
      'gender': gender,
      'country': country,
      'state': state,
      'city': city,
      'pinCode': pinCode,
      'qualification': qualification,
      'occupation': occupation,
      'interests': interests,
      'profileImageUrl': profileImageUrl,
      'referral': referral,
      'createdAt': DateTime.now(),
    };
  }
}

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
  final String? referral;
  final String? profileImageUrl;

  final List<String> education;
  final List<String> technology;
  final List<String> lifestyle;
  final List<String> entertainment;
  final List<String> careerAndMoney;
  final List<String> socialMedia;
  final List<String> personalGrowth;
  final List<String> regionalAndCultural;
  final List<String> wellbeingAndAwareness;

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
    required this.education,
    required this.technology,
    required this.lifestyle,
    required this.entertainment,
    required this.careerAndMoney,
    required this.socialMedia,
    required this.personalGrowth,
    required this.regionalAndCultural,
    required this.wellbeingAndAwareness,
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
      'education': education,
      'technology': technology,
      'lifestyle': lifestyle,
      'entertainment': entertainment,
      'careerAndMoney': careerAndMoney,
      'socialMedia': socialMedia,
      'personalGrowth': personalGrowth,
      'regionalAndCultural': regionalAndCultural,
      'wellbeingAndAwareness': wellbeingAndAwareness,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (referral != null) 'referral': referral,
    };
  }
}

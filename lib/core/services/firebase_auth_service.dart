import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithPhone(String mobile, String password) async {
    // NOTE: Replace this with secure verification, this is placeholder logic
    if (mobile == "9999999999" && password == "123456") {
      final credential = await _auth.signInAnonymously();
      return credential.user;
    } else {
      throw Exception("Invalid mobile or password");
    }
  }
}

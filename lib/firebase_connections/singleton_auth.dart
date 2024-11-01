import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  static final AuthenticationService _instance = AuthenticationService._internal();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  factory AuthenticationService() {
    return _instance;
  }

  AuthenticationService._internal();
}
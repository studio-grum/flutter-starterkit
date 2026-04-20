import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRepository {
  Stream<AuthState> get authStateChanges;
  User? get currentUser;
  Future<void> signInWithEmail(String email, String password);
  Future<void> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

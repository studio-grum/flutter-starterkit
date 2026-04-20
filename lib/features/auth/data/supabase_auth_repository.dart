import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:supabase_flutter/supabase_flutter.dart' as supa show AuthException;

import '../../../core/errors/app_exception.dart';
import '../domain/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  @override
  User? get currentUser => _client.auth.currentUser;

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on supa.AuthException catch (e) {
      throw AppAuthException(e.message, code: e.statusCode);
    }
  }

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _client.auth.signUp(email: email, password: password);
    } on supa.AuthException catch (e) {
      throw AppAuthException(e.message, code: e.statusCode);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on supa.AuthException catch (e) {
      throw AppAuthException(e.message, code: e.statusCode);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on supa.AuthException catch (e) {
      throw AppAuthException(e.message, code: e.statusCode);
    }
  }
}

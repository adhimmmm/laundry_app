import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  User? get currentUser => client.auth.currentUser;

  Future<void> signIn(String email, String password) async {
    await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(String email, String password) async {
    await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await client.auth.signOut();
  }
}

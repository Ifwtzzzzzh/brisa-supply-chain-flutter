import 'package:brisa_supply_chain/features/home/presentation/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class AuthService {
  // Create instances of Firebase Auth and Google Sign-In
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// A stream that notifies about changes to the user's sign-in state.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// The currently signed-in user.
  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithGoogle() async {
    try {
      // 1. Trigger the Google Sign-In authentication flow.
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // 3. Obtain the authentication details from the Google user.
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 4. Create a new Firebase credential using the Google tokens.
      final OAuthCredential credential = GoogleAuthProvider.credential(
        // accessToken: googleAuth.,
        idToken: googleAuth.idToken,
      );

      // 5. Sign in to Firebase with the credential.
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // 6. Return the Firebase user.
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (kDebugMode) {
        print('Firebase Auth Exception during Google Sign-In: ${e.message}');
      }
      rethrow; // Re-throw the exception to be handled by the UI
    } catch (e) {
      // Handle other errors (e.g., network issues)
      if (kDebugMode) {
        print('An unexpected error occurred during Google Sign-In: $e');
      }
      rethrow;
    }
  }

  /// Signs in the user with email and password.
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      // 1. Sign in to Firebase with email and password.
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: email.trim(), // .trim() removes any whitespace
            password: password,
          );

      // 2. Return the Firebase user.
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (kDebugMode) {
        print('Firebase Auth Exception during Email Sign-In: ${e.message}');
      }
      rethrow; // Re-throw the exception to be handled by the UI
    } catch (e) {
      // Handle other errors
      if (kDebugMode) {
        print('An unexpected error occurred during Email Sign-In: $e');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      MaterialPageRoute<void>(builder: (context) => const HomeScreen());
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign out: $e');
      }
      rethrow;
    }
  }
}

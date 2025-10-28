import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// 🔹 Class ini menangani seluruh proses autentikasi Firebase:
/// - Sign Up (Email/Password)
/// - Login (Email/Password)
/// - Login dengan Google
/// - Menyimpan data user ke Firestore
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Registrasi akun baru dengan Email & Password
  Future<User?> signUpWithEmail({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Buat akun baru di Firebase Authentication
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      // Simpan data user ke Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'signInMethod': 'email_password',
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// 🔹 Login dengan Email & Password
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  /// 🔹 Login menggunakan akun Google
  Future<User?> signInWithGoogle() async {
    try {
      // Jalankan proses sign in dari Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Login Google dibatalkan pengguna');
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Buat credential Firebase dari token Google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login ke Firebase Authentication
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      // Cek apakah user baru
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _firestore.collection('users').doc(user!.uid).set({
          'uid': user.uid,
          'username': user.displayName ?? 'User Baru',
          'email': user.email,
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'signInMethod': 'google',
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    } catch (e) {
      throw Exception('Login Google gagal: $e');
    }
  }

  /// 🔹 Logout
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  /// 🔹 Dapatkan user yang sedang login
  User? get currentUser => _auth.currentUser;

  /// 🔹 Private helper untuk translate error Firebase
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar.';
      case 'weak-password':
        return 'Password terlalu lemah.';
      default:
        return e.message ?? 'Terjadi kesalahan tidak diketahui.';
    }
  }
}

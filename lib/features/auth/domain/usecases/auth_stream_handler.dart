// File: auth_stream_handler.dart
import 'package:brisa_supply_chain/features/auth/presentation/screens/signin_screen.dart';
import 'package:brisa_supply_chain/features/home/presentation/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStreamHandler extends StatelessWidget {
  const AuthStreamHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen(); // Logged in
        }
        return const SigninScreen(); // Logged out
      },
    );
  }
}

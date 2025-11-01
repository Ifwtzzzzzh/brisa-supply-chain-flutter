// In your main.dart, or a new file like 'auth_wrapper.dart'
import 'package:brisa_supply_chain/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:brisa_supply_chain/features/home/presentation/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Make sure you have an instance of your AuthService available,
    // or just call FirebaseAuth.instance directly here.
    return StreamBuilder<User?>(
      // Listen to the auth state
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is logged in
        if (snapshot.hasData) {
          return const HomeScreen(); // Show HomeScreen
        }

        // If user is logged out
        return const OnboardingScreen(); // Show SignInScreen
      },
    );
  }
}

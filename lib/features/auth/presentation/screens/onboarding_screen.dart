// ignore_for_file: deprecated_member_use

import 'package:brisa_supply_chain/features/auth/presentation/screens/signin_screen.dart';
import 'package:brisa_supply_chain/features/auth/presentation/widgets/sign_up_dialog_widget.dart';
import 'package:brisa_supply_chain/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/onboarding_screen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Illustration Container
              Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(),
                child: Center(
                  child: Image.asset(
                    'assets/images/onboarding_illustration.png',
                    width: 292,
                    height: 292,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              // Title and Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Text(
                      'Platform On-Chain untuk\nAnalisa Harga Sembako',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Dapatkan data harga yang akurat, anti\nmanipulasi, dan dapat diverifikasi oleh siapa\nsaja, langsung pada jaringan blockchain.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              // Continue Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      SignUpDialogWidget.show(
                        context,
                        onYesPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => const SigninScreen(),
                            ),
                          );
                        },
                        onNoPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Lanjutkan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

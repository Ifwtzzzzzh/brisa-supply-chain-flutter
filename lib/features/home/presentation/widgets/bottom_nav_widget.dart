// ignore_for_file: deprecated_member_use

import 'package:brisa_supply_chain/core/usecases/colors.dart';
import 'package:brisa_supply_chain/features/home/presentation/screens/home_screen.dart';
import 'package:brisa_supply_chain/features/home/presentation/screens/profie_screen.dart';
import 'package:flutter/material.dart';

class BottomNavWidget extends StatelessWidget {
  final int currentIndex;

  const BottomNavWidget({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: currentIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => _onItemTapped(context, index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    // Don't navigate if already on the same page
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        // Navigate to Home Screen
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        // Navigate to Profile Screen
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    const ProfileScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
    }
  }
}

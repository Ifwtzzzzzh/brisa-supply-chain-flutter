import 'package:brisa_supply_chain/features/home/presentation/widgets/bottom_nav_widget.dart';
import 'package:flutter/material.dart';

// ignore_for_file: deprecated_member_use

import 'package:brisa_supply_chain/core/usecases/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 51, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Title
              const _ProfileHeader(),
              const SizedBox(height: 32),

              // Profile Picture
              const _ProfilePicture(),
              const SizedBox(height: 40),

              // Name Field
              const _ProfileField(label: 'Nama', value: 'Yuhaaaaaa'),
              const SizedBox(height: 24),

              // Email Field
              const _ProfileField(
                label: 'Email',
                value: 'yuhahearts2hearts@gmail.com',
              ),
              const SizedBox(height: 40),

              // Logout Button
              const _LogoutButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 1),
    );
  }
}

// --- Component Widgets ---

/// Profile Header with Title
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'My Profile ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        Text('🎀', style: TextStyle(fontSize: 20)),
      ],
    );
  }
}

/// Profile Picture Widget
class _ProfilePicture extends StatelessWidget {
  const _ProfilePicture();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: Colors.blue.shade100,
          child: Image.asset(
            'assets/images/profile_image.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

/// Reusable Profile Field Widget
class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Field
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: value,
            hintStyle: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 16),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            // 1. Base Border for all states when not focused or in error
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB), // Light grey color for general border
                width: 1.0,
              ),
            ),

            // 2. Enabled Border: Visible when not focused, but interactable
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB), // Light grey border
                width: 1.0,
              ),
            ),

            // 3. Focused Border: Prominently visible when the user clicks/taps to type (focus)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2.0, // Make it thicker to emphasize focus
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Logout Button Widget
class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle logout action
          _showLogoutDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Logout',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your logout logic here
                // e.g., Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

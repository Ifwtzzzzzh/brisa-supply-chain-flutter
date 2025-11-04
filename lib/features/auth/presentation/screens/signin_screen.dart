import 'package:brisa_supply_chain/core/usecases/colors.dart';
import 'package:brisa_supply_chain/features/auth/domain/usecases/firebase_auth.dart';
import 'package:brisa_supply_chain/features/auth/presentation/screens/signup_screen.dart';
import 'package:brisa_supply_chain/features/home/presentation/screens/home_screen.dart';
import 'package:brisa_supply_chain/features/question/presentation/screens/question_screen.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final AuthService _authService = AuthService();

  bool _isLoading = false; // <-- 1. ADD LOADING STATE VARIABLE

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // <-- 2. CREATE A FUNCTION FOR EMAIL SIGN-IN
  Future<void> _signInWithEmail() async {
    // Don't do anything if we are already loading
    if (_isLoading) return;

    // Hide keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the AuthService function
      await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
      // On success, the AuthWrapper/Stream will handle navigation
      // We don't need to set _isLoading = false, as the widget will unmount
    } catch (e) {
      // If sign-in fails, stop loading and show an error
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: ${e.toString()}')),
        );
      }
    }
  }

  // <-- 3. CREATE A FUNCTION FOR GOOGLE SIGN-IN
  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInWithGoogle();
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute<void>(builder: (context) => const QuestionScreen()),
      );
    } catch (e) {
      // If sign-in fails or is cancelled
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 51, left: 51, top: 133),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ... (Your Title, Email, and Password fields are all perfect)
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

                // Email Field
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'ex: jon.smith@email.com',
                    hintStyle: const TextStyle(
                      color: Color(0xFFD1D5DB),
                      fontSize: 16,
                    ),
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
                        color: Color(
                          0xFFE5E7EB,
                        ), // Light grey color for general border
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

                const SizedBox(height: 24),

                // Password Field
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '**********',
                    hintStyle: const TextStyle(
                      color: Color(0xFFD1D5DB),
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
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
                        color: Color(
                          0xFFE5E7EB,
                        ), // Light grey color for general border
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

                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9CA3AF),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Masuk Button
                ElevatedButton(
                  // <-- 4. UPDATE THE 'onPressed' CALLBACK
                  // Disable the button when loading
                  onPressed: _isLoading ? null : _signInWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA855F7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  // <-- 5. UPDATE THE CHILD TO SHOW A LOADER
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),

                const SizedBox(height: 24),

                // Atau masuk dengan
                const Text(
                  'atau masuk dengan',
                  style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Button
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        // <-- 6. UPDATE GOOGLE 'onPressed'
                        // Disable the button when loading
                        onPressed: _isLoading ? null : _signInWithGoogle,
                        // <-- 7. UPDATE THE ICON TO SHOW A LOADER
                        icon:
                            _isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                )
                                : Image.asset(
                                  'assets/images/google_logo.png',
                                  width: 24,
                                  height: 24,
                                ),
                        iconSize: 24,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Apple Button
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        // <-- 8. DISABLE APPLE BUTTON WHILE LOADING
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  // Handle Apple sign in
                                },
                        icon: const Icon(
                          Icons.apple,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA855F7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

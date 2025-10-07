import 'package:brisa_supply_chain/core/usecases/colors.dart';
import 'package:flutter/material.dart';

class NextButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const NextButtonWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60, // Consistent height for the main action button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary, // Purple color
          disabledBackgroundColor: const Color(
            0xFFB39DDB,
          ), // Lighter purple for disabled
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Selanjutnya', // Next
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OptionsButtonWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const OptionsButtonWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55, // Fixed height for a consistent look
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor:
              isSelected
                  ? const Color(0xFFE8F5E9)
                  : Colors.white, // Light green for selected
          side: BorderSide(
            color:
                isSelected
                    ? const Color(0xFF4CAF50) // Green border for selected
                    : Colors.grey.shade300, // Light grey border for unselected
            width: isSelected ? 2.0 : 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

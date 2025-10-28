// ignore_for_file: unnecessary_to_list_in_spreads, avoid_print

import 'package:brisa_supply_chain/core/usecases/colors.dart';
import 'package:brisa_supply_chain/features/question/presentation/widgets/next_button_widget.dart';
import 'package:brisa_supply_chain/features/question/presentation/widgets/options_button_widget.dart';
import 'package:brisa_supply_chain/features/question/presentation/widgets/progress_header_widget.dart';
import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // State to hold the currently selected option
  String? _selectedProfession;
  // Dummy list of options for the question
  final List<String> _professionOptions = const [
    'Pengusaha', // Entrepreneur
    'Petani', // Farmer
    'Pembeli', // Buyer/Customer
    'Lain-lain', // Other
  ];

  void _selectOption(String option) {
    setState(() {
      _selectedProfession = option;
    });
  }

  void _nextQuestion() {
    // Logic to handle moving to the next question (Selanjutnya)
    // For this example, we'll just print the selection.
    print('Selected profession: $_selectedProfession');
    // In a real app, you would navigate:
    // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NextScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen for responsive padding
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary, // Deep purple background
      body: SafeArea(
        child: Column(
          children: [
            // Header: "Questions"
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.03),
              child: const Text(
                'Questions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            // Main Content Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                  left: 30,
                  right: 30,
                  bottom: 134,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 30.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Progress Bar & Counter (Total Pertanyaan 1/4)
                        const ProgressHeaderWidget(current: 1, total: 4),
                        const SizedBox(height: 30),

                        // Question Text (Apa profesi anda ??)
                        const Text(
                          'Apa profesi anda ??',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Options List
                        ..._professionOptions.map((option) {
                          final isSelected = _selectedProfession == option;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: OptionsButtonWidget(
                              text: option,
                              isSelected: isSelected,
                              onPressed: () => _selectOption(option),
                            ),
                          );
                        }).toList(),

                        const Spacer(), // Pushes the next button to the bottom
                        // Next Button (Selanjutnya)
                        NextButtonWidget(
                          onPressed:
                              _selectedProfession != null
                                  ? _nextQuestion
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

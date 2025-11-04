// ignore_for_file: unnecessary_to_list_in_spreads, avoid_print

import 'package:brisa_supply_chain/core/usecases/colors.dart'; //
import 'package:brisa_supply_chain/features/home/presentation/screens/home_screen.dart';
import 'package:brisa_supply_chain/features/question/data/models/question_model.dart';
import 'package:brisa_supply_chain/features/question/data/repositories/question_data.dart';
import 'package:brisa_supply_chain/features/question/presentation/widgets/next_button_widget.dart';
import 'package:brisa_supply_chain/features/question/presentation/widgets/options_button_widget.dart';
import 'package:brisa_supply_chain/features/question/presentation/widgets/progress_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

// Kita ganti nama jadi QuizScreen biar lebih jelas
class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // Ambil data pertanyaan dari file data terpisah
  final List<QuestionModel> _questions = QuizData.questions;
  final _logger = Logger(); // <-- TAMBAHKAN INI

  // Ambil data pertanyaan dari file data terpisah

  // State untuk tracking
  int _currentQuestionIndex = 0;
  // Map untuk menyimpan jawaban: <index pertanyaan, jawaban yg dipilih>
  final Map<int, String> _answers = {};

  void _selectOption(String option) {
    setState(() {
      // Simpan jawaban untuk index saat ini
      _answers[_currentQuestionIndex] = option;
    });
  }

  void _nextQuestion() {
    // Cek apakah ini pertanyaan terakhir
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++; // Pindah ke pertanyaan selanjutnya
      });
    } else {
      _logger.i('--- Quiz Selesai, Menavigasi ke Home ---');
      _answers.forEach((index, answer) {
        _logger.i('Q${index + 1}: $answer');
      });

      // Ganti navigasi ke HomeScreen
      // Kita pakai 'pushReplacement' agar user tidak bisa back ke quiz
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const HomeScreen()),
      );
    }
  }

  // Helper untuk mendapatkan jawaban yg dipilih saat ini
  String? get _selectedOptionForCurrentQuestion {
    return _answers[_currentQuestionIndex];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Ambil data pertanyaan saat ini secara dinamis
    final QuestionModel currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppColors.primary,
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
                        // --- MULAI BAGIAN DINAMIS ---

                        // Progress Bar & Counter (Dinamis)
                        ProgressHeaderWidget(
                          current: _currentQuestionIndex + 1, // Dinamis
                          total: _questions.length, // Dinamis
                        ),
                        const SizedBox(height: 30),

                        // Question Text (Dinamis)
                        Text(
                          currentQuestion.questionText, // Dinamis
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Options List (Dinamis)
                        ...currentQuestion.options.map((option) {
                          // Cek apakah opsi ini yg sedang dipilih
                          final isSelected =
                              _selectedOptionForCurrentQuestion == option;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: OptionsButtonWidget(
                              text: option,
                              isSelected: isSelected,
                              onPressed: () => _selectOption(option),
                            ),
                          );
                        }),

                        // --- AKHIR BAGIAN DINAMIS ---
                        const Spacer(), // Pushes the next button to the bottom
                        // Next Button (Selanjutnya)
                        NextButtonWidget(
                          // Aktifkan tombol jika ada jawaban yg dipilih
                          onPressed:
                              _selectedOptionForCurrentQuestion != null
                                  ? _nextQuestion
                                  : null,
                          // Ganti teks tombol di pertanyaan terakhir
                          text:
                              _currentQuestionIndex == _questions.length - 1
                                  ? 'Selesai'
                                  : 'Selanjutnya',
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

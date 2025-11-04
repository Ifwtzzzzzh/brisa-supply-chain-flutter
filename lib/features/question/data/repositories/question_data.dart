import '../models/question_model.dart';

// Ini adalah data source yang terpisah dari UI
class QuizData {
  static const List<QuestionModel> questions = [
    QuestionModel(
      questionText: 'Apa profesi anda ??',
      options: ['Pengusaha', 'Petani', 'Pembeli', 'Lain-lain'],
    ),
    QuestionModel(
      questionText: 'Di mana domisili anda ??',
      options: ['Jabodetabek', 'Sumatera', 'Jawa', 'Lain-lain'],
    ),
    QuestionModel(
      questionText: 'Harga sembako apa yang ingin anda cari??',
      options: ['Beras', 'Minyak Makan', 'Gula', 'Lain-lain'],
    ),
    QuestionModel(
      questionText: 'Apa tujuan anda dari aplikasi ini??',
      options: [
        'Mencari Data Sembako',
        'Mencari Peluang Usaha',
        'Analisis Data Sembako',
        'Lain-lain',
      ],
    ),
  ];
}

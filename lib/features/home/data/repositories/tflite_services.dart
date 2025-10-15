import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteServices {
  late Interpreter _interpreter;
  bool _isLoaded = false;
  final String _modelPath =
      'assets/models/next_month_regressor.tflite'; // Path model

  // Model ini hanya perlu di-load sekali
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      _isLoaded = true;
      print('Model $_modelPath berhasil dimuat!');

      // **PENTING: Cek shape input/output model lo**
      print('Input Shape: ${_interpreter.getInputTensor(0).shape}');
      print('Output Shape: ${_interpreter.getOutputTensor(0).shape}');
    } catch (e) {
      print('Gagal memuat model TFLite: $e');
    }
  }

  void dispose() {
    _interpreter.close();
  }

  Future<List<double>> predictNextMonth(List<double> features) async {
    if (!_isLoaded) {
      // Tidak perlu throw exception, cukup kembalikan dummy jika model gagal load
      // Pada lingkungan produksi, ini harusnya throw exception atau log error.
      print("Warning: Model TFLite belum dimuat, mengembalikan hasil dummy.");
      return [16500.0]; // Nilai dummy jika model gagal
    }

    // 1. Persiapan Input: Sesuaikan dengan 'Input Shape' model lo.
    var input = [features];

    // 2. Persiapan Output: Sesuaikan dengan 'Output Shape' model lo ([1, 1])
    var output = List<double>.filled(1 * 1, 0).reshape([1, 1]);

    // 3. Jalankan Inferensi
    _interpreter.run(input, output);

    // 4. Kembalikan Hasil Prediksi (nilai tunggal)
    return output[0].cast<double>();
  }
}

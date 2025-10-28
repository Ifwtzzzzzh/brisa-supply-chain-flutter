import 'package:tflite_flutter/tflite_flutter.dart';

class CommodityData {
  final String commodity;
  final double predNextMonthPrice;
  final int cluster;

  CommodityData({
    required this.commodity,
    required this.predNextMonthPrice,
    required this.cluster,
  });

  // Convert to Map for easy serialization
  Map<String, dynamic> toMap() {
    return {
      'commodity': commodity,
      'pred_next_month_price': predNextMonthPrice,
      'cluster': cluster,
    };
  }

  // Create from Map
  factory CommodityData.fromMap(Map<String, dynamic> map) {
    return CommodityData(
      commodity: map['commodity'] as String,
      predNextMonthPrice: map['pred_next_month_price'] as double,
      cluster: map['cluster'] as int,
    );
  }
}

class TfliteServices {
  late Interpreter _interpreter;
  bool _isLoaded = false;
  final String _modelPath = 'assets/models/next_month_regressor.tflite';

  // Static data dari CSV - Data prediksi untuk semua komoditas
  static final List<CommodityData> _commodityPredictions = [
    CommodityData(
      commodity: 'Beras Kualitas Bawah II',
      predNextMonthPrice: 14298.2470703125,
      cluster: 0,
    ),
    CommodityData(
      commodity: 'Beras Kualitas Bawah I',
      predNextMonthPrice: 14647.2412109375,
      cluster: 0,
    ),
    CommodityData(
      commodity: 'Beras Kualitas Medium II',
      predNextMonthPrice: 15655.9501953125,
      cluster: 0,
    ),
    CommodityData(
      commodity: 'Beras',
      predNextMonthPrice: 15745.017578125,
      cluster: 0,
    ),
    CommodityData(
      commodity: 'Beras Kualitas Medium I',
      predNextMonthPrice: 15869.9853515625,
      cluster: 0,
    ),
    CommodityData(
      commodity: 'Beras Kualitas Super II',
      predNextMonthPrice: 16584.158203125,
      cluster: 0,
    ),
    CommodityData(
      commodity: 'Beras Kualitas Super I',
      predNextMonthPrice: 17123.884765625,
      cluster: 0,
    ),
    CommodityData(
      commodity: 'Minyak Goreng Curah',
      predNextMonthPrice: 18765.703125,
      cluster: 0,
    ),
    CommodityData(
      commodity: 'Minyak Goreng',
      predNextMonthPrice: 21065.517578125,
      cluster: 0,
    ),
    CommodityData(
      commodity: 'Minyak Goreng Kemasan Bermerk 2',
      predNextMonthPrice: 21622.642578125,
      cluster: 0,
    ),
    CommodityData(
      commodity: 'Minyak Goreng Kemasan Bermerk 1',
      predNextMonthPrice: 22381.490234375,
      cluster: 0,
    ),
    CommodityData(
      commodity: 'Telur Ayam',
      predNextMonthPrice: 30278.427734375,
      cluster: 2,
    ),
    CommodityData(
      commodity: 'Telur Ayam Ras Segar',
      predNextMonthPrice: 30279.80078125,
      cluster: 2,
    ),
    CommodityData(
      commodity: 'Daging Ayam Ras Segar',
      predNextMonthPrice: 36792.09375,
      cluster: 2,
    ),
    CommodityData(
      commodity: 'Daging Ayam',
      predNextMonthPrice: 36803.3359375,
      cluster: 2,
    ),
  ];

  // Load model TFLite
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      _isLoaded = true;
      print('✅ Model $_modelPath berhasil dimuat!');
      print('📊 Input Shape: ${_interpreter.getInputTensor(0).shape}');
      print('📊 Output Shape: ${_interpreter.getOutputTensor(0).shape}');
    } catch (e) {
      _isLoaded = false;
      print('❌ Gagal memuat model TFLite: $e');
      rethrow; // Throw error agar bisa di-handle di UI
    }
  }

  // Dispose interpreter
  void dispose() {
    if (_isLoaded) {
      _interpreter.close();
      _isLoaded = false;
      print('🗑️ TFLite Interpreter ditutup');
    }
  }

  // Get all commodity predictions
  List<CommodityData> getAllCommodities() {
    return _commodityPredictions;
  }

  // Get specific commodity by name
  CommodityData? getCommodityByName(String commodityName) {
    try {
      return _commodityPredictions.firstWhere(
        (commodity) =>
            commodity.commodity.toLowerCase() == commodityName.toLowerCase(),
      );
    } catch (e) {
      print('⚠️ Komoditas "$commodityName" tidak ditemukan');
      return null;
    }
  }

  // Get commodities by cluster
  List<CommodityData> getCommoditiesByCluster(int cluster) {
    return _commodityPredictions
        .where((commodity) => commodity.cluster == cluster)
        .toList();
  }

  // Predict next month price using TFLite model
  Future<double> predictNextMonth(List<double> features) async {
    if (!_isLoaded) {
      print("⚠️ Warning: Model TFLite belum dimuat");
      throw Exception(
        'Model TFLite belum dimuat. Panggil loadModel() terlebih dahulu.',
      );
    }

    try {
      // 1. Persiapan Input: Sesuaikan dengan 'Input Shape' model
      var input = [features];

      // 2. Persiapan Output: Sesuaikan dengan 'Output Shape' model ([1, 1])
      var output = List<double>.filled(1 * 1, 0).reshape([1, 1]);

      // 3. Jalankan Inferensi
      _interpreter.run(input, output);

      // 4. Kembalikan Hasil Prediksi (nilai tunggal)
      final prediction = output[0][0];
      print('🎯 Prediksi TFLite: $prediction');
      return prediction;
    } catch (e) {
      print('❌ Error running prediction: $e');
      rethrow;
    }
  }

  // Predict for specific commodity by name
  Future<CommodityData?> predictCommodity(
    String commodityName,
    List<double> features,
  ) async {
    try {
      // Get commodity data
      final commodityData = getCommodityByName(commodityName);
      if (commodityData == null) {
        print('⚠️ Komoditas "$commodityName" tidak ditemukan dalam database');
        return null;
      }

      // Run TFLite prediction
      final predictedPrice = await predictNextMonth(features);

      // Return updated commodity data with new prediction
      return CommodityData(
        commodity: commodityData.commodity,
        predNextMonthPrice: predictedPrice,
        cluster: commodityData.cluster,
      );
    } catch (e) {
      print('❌ Error predicting commodity: $e');
      return null;
    }
  }

  // Get Beras Kualitas Super I specifically
  CommodityData? getBerasKualitasSuper1() {
    return getCommodityByName('Beras Kualitas Super I');
  }

  // Predict Beras Kualitas Super I with TFLite
  Future<CommodityData?> predictBerasKualitasSuper1(
    List<double> features,
  ) async {
    return await predictCommodity('Beras Kualitas Super I', features);
  }

  // Get summary statistics
  Map<String, dynamic> getStatistics() {
    final prices =
        _commodityPredictions.map((c) => c.predNextMonthPrice).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final avgPrice = prices.reduce((a, b) => a + b) / prices.length;

    return {
      'total_commodities': _commodityPredictions.length,
      'min_price': minPrice,
      'max_price': maxPrice,
      'avg_price': avgPrice,
      'clusters': _commodityPredictions.map((c) => c.cluster).toSet().toList(),
    };
  }

  // Check if model is loaded
  bool get isModelLoaded => _isLoaded;
}

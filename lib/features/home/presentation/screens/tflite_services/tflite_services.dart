import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class CommodityData {
  final String commodity;
  final double predNextMonthPrice;
  final String cluster;

  CommodityData({
    required this.commodity,
    required this.predNextMonthPrice,
    required this.cluster,
  });

  factory CommodityData.fromJson(Map<String, dynamic> json) {
    return CommodityData(
      commodity: json['commodity'],
      predNextMonthPrice: (json['predNextMonthPrice'] as num).toDouble(),
      cluster: json['cluster'].toString(),
    );
  }
}

class TfliteServices {
  Interpreter? _interpreter;
  List<double>? _mean;
  List<double>? _scale;
  List<Map<String, dynamic>>? _csvData;

  /// Load model TFLite, scaler params, dan data CSV
  Future<void> loadAllAssets() async {
    try {
// Load model (hanya sekali)
      _interpreter ??= await Interpreter.fromAsset(
        'assets/models/next_month_regressor.tflite',
      );

      // Load scaler params
      final scalerJson =
      await rootBundle.loadString('assets/models/scaler_params.json');
      final Map<String, dynamic> scalerData = jsonDecode(scalerJson);
      _mean = (scalerData['mean'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList();
      _scale = (scalerData['scale'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList();

      // Load CSV hasil fitur komoditas
      final csvString =
      await rootBundle.loadString('assets/models/predicted_next_month_prices.csv');
      _csvData = const LineSplitter()
          .convert(csvString)
          .skip(1)
          .map((line) {
        final parts = line.split(',');
        return {
          'commodity': parts[0],
          'features': parts
              .skip(1)
              .map((v) => double.tryParse(v) ?? 0.0)
              .toList(),
        };
      }).toList();

      log("✅ Model, scaler, dan CSV loaded");
    } catch (e) {
      log("❌ Error loading assets: $e");
      rethrow;
    }
  }

  /// Jalankan prediksi untuk satu komoditas
  Future<double> runPredictionForCommodity(String commodity) async {
    await loadAllAssets();

  // Cari data komoditas di CSV
    final item = _csvData!.firstWhere(
          (e) => e['commodity'] == commodity,
      orElse: () => throw Exception('Commodity $commodity not found in CSV'),
    );

    if (item.isEmpty) {
      throw Exception("Commodity '$commodity' not found in CSV data");
    }

    final inputRaw = (item['features'] as List<double>);
    if (_mean == null || _scale == null) {
      throw Exception("Scaler not loaded");
    }

// Normalisasi input sesuai mean dan scale
    final normalized = List<double>.generate(
      inputRaw.length,
          (i) => (inputRaw[i] - _mean![i]) / _scale![i],
    );

    final input = [normalized];
    final output = List.filled(1, 0.0).reshape([1, 1]);

    try {
      _interpreter!.run(input, output);
      final prediction = output[0][0];
      log("🔮 Prediction for $commodity = $prediction");
      return prediction;
    } catch (e) {
      log("❌ Error running inference: $e");
      rethrow;
    }


  }

  /// Jalankan prediksi untuk semua komoditas
  Future<List<CommodityData>> predictAllCommodities() async {
    await loadAllAssets();

    List<CommodityData> results = [];

    for (final row in _csvData!) {
      final commodity = row['commodity'].toString();
      final features = (row['features'] as List<double>);

      final normalized = List<double>.generate(
        features.length,
            (i) => (features[i] - _mean![i]) / _scale![i],
      );

      final input = [normalized];
      final output = List.filled(1, 0.0).reshape([1, 1]);
      _interpreter!.run(input, output);
      final pred = output[0][0];

      results.add(
        CommodityData(
          commodity: commodity,
          predNextMonthPrice: pred,
          cluster: "0",
        ),
      );
    }

    log("✅ All predictions done (${results.length} items)");
    return results;


  }

  void close() {
    _interpreter?.close();
  }
}
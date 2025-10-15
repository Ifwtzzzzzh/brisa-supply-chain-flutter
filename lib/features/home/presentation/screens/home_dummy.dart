// ignore_for_file: deprecated_member_use

import 'package:brisa_supply_chain/features/home/data/repositories/tflite_services.dart';
import 'package:brisa_supply_chain/features/home/presentation/widgets/bottom_nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl untuk formatting Rupiah yang lebih baik

// --- Models (Simplified for this example) ---

class IndexData {
  // ... (Kode IndexData tetap sama) ...
  final String title;
  final double value;
  final double change;
  final Color changeColor;

  IndexData({
    required this.title,
    required this.value,
    required this.change,
    required this.changeColor,
  });
}

class PriceData {
  // ... (Kode PriceData tetap sama) ...
  final String name;
  final String price;
  final double change;

  PriceData({required this.name, required this.price, required this.change});
}

// --- Main Screen Widget ---

class HomeScreen extends StatefulWidget {
  // ... (Kode HomeScreen tetap sama) ...
  const HomeScreen({super.key});

  // Dummy data to match the screenshot
  static final List<IndexData> indexData = [
    IndexData(
      title: 'IHK',
      value: 108.57,
      change: 0.046,
      changeColor: Colors.green,
    ),
    IndexData(
      title: 'IHPB',
      value: 108.15,
      change: 1.454,
      changeColor: Colors.green,
    ),
    IndexData(
      title: 'IHP',
      value: 153.47,
      change: 0.857,
      changeColor: Colors.green,
    ),
    IndexData(
      title: 'IHKP',
      value: 122.69,
      change: 0.097,
      changeColor: Colors.green,
    ),
  ];

  static final List<PriceData> priceData = [
    PriceData(name: 'Beras Premium', price: 'Rp. 16,095', change: -0.86),
    PriceData(name: 'Beras Medium', price: 'Rp. 13,997', change: -0.59),
    PriceData(name: 'Bawang Merah', price: 'Rp. 46,868', change: -2.58),
    PriceData(name: 'Bawang Putih', price: 'Rp. 37,558', change: -1.49),
    PriceData(name: 'Cabai Merah Keriting', price: 'Rp. 40,532', change: -0.67),
    PriceData(name: 'Cabai Merah Besar', price: 'Rp. 40,998', change: -1.45),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TfliteServices _tfliteService = TfliteServices();
  String _predictionResult = 'Tekan tombol untuk prediksi...';
  Map<String, String> _predictedPrices = {};

  @override
  void initState() {
    super.initState();
    _tfliteService.loadModel();
  }

  final List<double> dummyInput = [
    0.1,
    0.5,
    0.3,
    0.8,
    0.2,
  ]; // Sesuai jumlah fitur model lo!

  void _runPrediction() async {
    setState(() {
      _predictionResult = 'Sedang memproses...';
    });

    try {
      final results = await _tfliteService.predictNextMonth(dummyInput);
      final predictedValue = results[0];

      // Asumsi: Model memprediksi harga untuk komoditas pertama (Beras Premium)
      // Kita format hasilnya sebagai Rupiah
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp. ',
        decimalDigits: 0,
      );
      final predictedPriceFormatted = formatter.format(predictedValue);

      setState(() {
        // Tampilkan hasil prediksi dengan asumsi ini adalah prediksi Beras Premium
        _predictionResult =
            'Prediksi Beras Premium (1 Bulan): $predictedPriceFormatted';
      });
    } catch (e) {
      setState(() {
        _predictionResult = 'Error TFLite: Gagal menjalankan prediksi.';
        print('Error running prediction: $e');
      });
    }
  }

  @override
  void dispose() {
    // Bersihkan interpreter saat widget dihapus
    _tfliteService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // // 1. User/Greeting Section
              // const _UserGreeting(),
              const SizedBox(height: 16),

              // 2. Index Cards Section
              // _IndexCardRow(data: HomeScreen.indexData),
              const SizedBox(height: 24),

              // 3. Trending Section (Text + Chips)
              // const _TrendingSection(),
              const SizedBox(height: 24),

              // 4. Harga Terkini Header
              Text(
                'Harga Terkini 💳',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _runPrediction,
                child: Text('Dapatkan Prediksi'),
              ),

              // --- TAMBAHAN: Menampilkan Hasil Prediksi di UI ---
              const SizedBox(height: 8),
              Text(
                _predictionResult,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 16),
              // ----------------------------------------------------

              // 5. Price Cards Grid
              // _PriceGrid(priceData: HomeScreen.priceData),
            ],
          ),
        ),
      ),
      // 6. Bottom Navigation Bar (Simplified)
      bottomNavigationBar: const BottomNavWidget(currentIndex: 0),
    );
  }
}

// ... (Component Widgets: _UserGreeting, _IndexCard, _IndexCardRow, _TrendingSection, _TrendingChip, _PriceCard, _PriceGrid tetap sama) ...

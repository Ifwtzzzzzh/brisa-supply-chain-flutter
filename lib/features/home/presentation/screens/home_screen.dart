// ignore_for_file: deprecated_member_use

// import 'package:brisa_supply_chain/features/home/data/repositories/tflite_services.dart';
import 'dart:developer';

import 'package:brisa_supply_chain/features/home/presentation/widgets/bottom_nav_widget.dart';
import 'package:brisa_supply_chain/features/home/presentation/screens/tflite_services/tflite_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- Models (Simplified for this example) ---
class IndexData {
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
  final String name;
  final String price;
  final double change;

  PriceData({required this.name, required this.price, required this.change});
}

// --- Main Screen Widget ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final List<IndexData> indexData = [
    IndexData(title: 'IHK', value: 108.57, change: 0.046, changeColor: Colors.green),
    IndexData(title: 'IHPB', value: 108.15, change: 1.454, changeColor: Colors.green),
    IndexData(title: 'IHP', value: 153.47, change: 0.857, changeColor: Colors.green),
    IndexData(title: 'IHKP', value: 122.69, change: 0.097, changeColor: Colors.green),
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

  final List<double> dummyInput = [0.1, 0.5, 0.3, 0.8, 0.2];

  //Daftar komoditas untuk pilihan dialog
  final List<String> _commodityOptions = [
    'Beras Kualitas Bawah II',
    'Beras Kualitas Bawah I',
    'Beras Kualitas Medium II',
    'Beras',
    'Beras Kualitas Medium I',
    'Beras Kualitas Super II',
    'Beras Kualitas Super I',
    'Minyak Goreng Curah',
    'Minyak Goreng',
    'Minyak Goreng Kemasan Bermerk 2',
    'Minyak Goreng Kemasan Bermerk 1',
    'Telur Ayam',
    'Telur Ayam Ras Segar',
    'Daging Ayam Ras Segar',
    'Daging Ayam',
  ];

  //Format angka jadi Rupiah
  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 2,
    );
    return formatter.format(price);
  }

  //Tampilkan dialog pilihan komoditas
  void _showPredictionSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Komoditas untuk Prediksi'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _commodityOptions.length,
              itemBuilder: (context, index) {
                final item = _commodityOptions[index];
                return ListTile(
                  title: Text(item),
                  onTap: () async {
                    Navigator.pop(context); // Tutup dialog
                    await _runPrediction(item);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Jalankan prediksi TFLite untuk komoditas terpilih
  Future<void> _runPrediction(String selectedItem) async {
    try {
      // Panggil fungsi prediksi di service
      final result = await _tfliteService.runPredictionForCommodity(selectedItem);

      if (!mounted) return;

      // Tampilkan hasil prediksi di dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hasil Prediksi'),
          content: Text(
            'Prediksi harga bulan depan untuk:\n\n'
                '$selectedItem\n\n'
                '➡️ ${_formatPrice(result)}',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    } catch (e, stack) {
      // Jika gagal prediksi, tampilkan pesan error
      log("❌ Error saat prediksi: $e\n$stack");

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Terjadi Kesalahan'),
          content: Text(
            'Gagal menjalankan prediksi untuk $selectedItem.\n\nDetail error:\n$e',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _UserGreeting(),
              const SizedBox(height: 16),
              _IndexCardRow(data: HomeScreen.indexData),
              const SizedBox(height: 24),
              const _TrendingSection(),
              const SizedBox(height: 24),

              Text(
                'Harga & Prediksi 📈',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),

              //Tombol baru dengan dialog popup pilihan
              ElevatedButton(
                onPressed: () {
                  _showPredictionSelectionDialog(context);
                },
                child: const Text('Jalankan Prediksi TFLite'),
              ),

              const SizedBox(height: 12),

              _PriceGrid(priceData: HomeScreen.priceData),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 0),
    );
  }
}

// --- Component Widgets ---
class _UserGreeting extends StatelessWidget {
  const _UserGreeting();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: AssetImage('assets/images/profile_image.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Hello Yuhaaa ~', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text('Selamat datang, Yuhaaa 🤝', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

class _IndexCardRow extends StatelessWidget {
  final List<IndexData> data;
  const _IndexCardRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: data.map((d) => _IndexCard(data: d)).toList(),
    );
  }
}

class _IndexCard extends StatelessWidget {
  final IndexData data;
  const _IndexCard({required this.data});

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFFF3EDF5);
    final isPositive = data.change > 0;
    final changeIcon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
    final changeColor = isPositive ? Colors.green.shade600 : Colors.red.shade600;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text(data.value.toStringAsFixed(2), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(changeIcon, size: 14, color: changeColor),
                const SizedBox(width: 4),
                Text('${data.change.abs().toStringAsFixed(3)}%', style: TextStyle(fontSize: 12, color: changeColor, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingSection extends StatelessWidget {
  const _TrendingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trending 🔥', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _TrendingChip(text: 'Apa update harga sembako hari ini??'),
              SizedBox(width: 8),
              _TrendingChip(text: 'Apa peluang usaha hari ini?'),
              SizedBox(width: 8),
              _TrendingChip(text: 'Trending lainnya...'),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrendingChip extends StatelessWidget {
  final String text;
  const _TrendingChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EDF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
    );
  }
}

class _PriceGrid extends StatelessWidget {
  final List<PriceData> priceData;
  const _PriceGrid({required this.priceData});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: priceData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        return _PriceCard(data: priceData[index]);
      },
    );
  }
}

class _PriceCard extends StatelessWidget {
  final PriceData data;
  const _PriceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isPositive = data.change > 0;
    final changeIcon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
    final changeColor = isPositive ? Colors.green.shade600 : Colors.red.shade600;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.name, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(data.price, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('${data.change.toStringAsFixed(2)}%', style: TextStyle(fontSize: 14, color: changeColor, fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              Icon(changeIcon, size: 14, color: changeColor),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [Colors.purple.shade100.withOpacity(0.5), Colors.purple.shade50.withOpacity(0.2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(child: Text('Chart Placeholder', style: TextStyle(fontSize: 10, color: Colors.purple))),
            ),
          ),
        ],
      ),
    );
  }
}

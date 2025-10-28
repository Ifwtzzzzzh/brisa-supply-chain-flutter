// ignore_for_file: deprecated_member_use

import 'package:brisa_supply_chain/features/home/data/repositories/tflite_services.dart';
import 'package:brisa_supply_chain/features/home/presentation/widgets/bottom_nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- Main Screen Widget ---

class HomeDummy2 extends StatefulWidget {
  const HomeDummy2({super.key});

  @override
  State<HomeDummy2> createState() => _HomeDummy2State();
}

class _HomeDummy2State extends State<HomeDummy2> {
  final TfliteServices _tfliteService = TfliteServices();
  bool _isLoading = false;
  CommodityData? _berasSuper1Data;
  CommodityData? _predictedData;
  String _errorMessage = '';

  // Feature data untuk prediksi (sesuaikan dengan model Anda)
  // Contoh: [harga_historis, inflasi, ihk, ihpb, seasonality, dll]
  final List<double> _features = [
    16500.0, // Feature 1: Harga bulan ini
    0.5, // Feature 2: Contoh fitur lainnya
    0.3, // Feature 3
    0.8, // Feature 4
    0.2, // Feature 5
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Load TFLite model
      await _tfliteService.loadModel();

      // Get Beras Kualitas Super I data dari CSV
      final berasData = _tfliteService.getBerasKualitasSuper1();

      if (berasData != null) {
        setState(() {
          _berasSuper1Data = berasData;
        });
        print('✅ Data Beras Kualitas Super I dimuat');
        print('📦 Harga prediksi CSV: Rp. ${berasData.predNextMonthPrice}');
      } else {
        throw Exception('Data Beras Kualitas Super I tidak ditemukan');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error saat inisialisasi: $e';
      });
      print('❌ Initialization error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _runTflitePrediction() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Jalankan prediksi menggunakan TFLite model
      final predictedData = await _tfliteService.predictBerasKualitasSuper1(
        _features,
      );

      if (predictedData != null) {
        setState(() {
          _predictedData = predictedData;
        });
        print('✅ Prediksi TFLite berhasil');
        print(
          '🎯 Harga prediksi TFLite: Rp. ${predictedData.predNextMonthPrice}',
        );
      } else {
        throw Exception('Gagal mendapatkan prediksi dari model');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error saat prediksi: $e';
      });
      print('❌ Prediction error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  @override
  void dispose() {
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
              const SizedBox(height: 16),

              // Header
              _buildHeader(),

              const SizedBox(height: 24),

              // Main Content
              if (_isLoading)
                _buildLoadingCard()
              else if (_errorMessage.isNotEmpty)
                _buildErrorCard()
              else
                _buildContentCards(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(currentIndex: 0),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.analytics_outlined, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prediksi Harga Komoditas',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Beras Kualitas Super I',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
            ),
            const SizedBox(height: 16),
            Text(
              'Memuat data dan model AI...',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      elevation: 3,
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 48),
            const SizedBox(height: 12),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.red.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _initializeData,
              icon: Icon(Icons.refresh),
              label: Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCards() {
    return Column(
      children: [
        // CSV Data Card
        if (_berasSuper1Data != null) _buildCsvDataCard(_berasSuper1Data!),

        const SizedBox(height: 16),

        // TFLite Prediction Card
        if (_predictedData != null) _buildPredictionCard(_predictedData!),

        const SizedBox(height: 24),

        // Action Buttons
        _buildActionButtons(),

        const SizedBox(height: 24),

        // Info Card
        _buildInfoCard(),
      ],
    );
  }

  Widget _buildCsvDataCard(CommodityData data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.green.shade600, Colors.green.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.storage, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data CSV',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          data.commodity,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Cluster ${data.cluster}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(height: 1, color: Colors.white.withOpacity(0.3)),
              const SizedBox(height: 20),
              Text(
                'Prediksi Harga (CSV)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatPrice(data.predNextMonthPrice),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionCard(CommodityData data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prediksi TFLite AI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          data.commodity,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Cluster ${data.cluster}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(height: 1, color: Colors.white.withOpacity(0.3)),
              const SizedBox(height: 20),
              Text(
                'Prediksi Harga (AI)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatPrice(data.predNextMonthPrice),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Diperbarui: ${_formatDate(DateTime.now())}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Run Prediction Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _runTflitePrediction,
            icon: Icon(Icons.play_arrow),
            label: Text(
              _predictedData == null
                  ? 'Jalankan Prediksi AI'
                  : 'Perbarui Prediksi AI',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // View All Commodities Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showAllCommodities(),
            icon: Icon(Icons.list_alt),
            label: Text(
              'Lihat Semua Komoditas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.blue.shade700, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Informasi Prediksi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '• Data CSV: Prediksi harga dari dataset historis\n'
                  '• Prediksi AI: Menggunakan model TensorFlow Lite\n'
                  '• Cluster: Pengelompokan komoditas berdasarkan karakteristik',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllCommodities() {
    final allCommodities = _tfliteService.getAllCommodities();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.list, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Semua Komoditas (${allCommodities.length})',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: allCommodities.length,
                    itemBuilder: (context, index) {
                      final commodity = allCommodities[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                            commodity.cluster == 0
                                ? Colors.green.shade100
                                : Colors.orange.shade100,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                commodity.cluster == 0
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                              ),
                            ),
                          ),
                          title: Text(
                            commodity.commodity,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            'Cluster ${commodity.cluster}',
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: Text(
                            _formatPrice(commodity.predNextMonthPrice),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
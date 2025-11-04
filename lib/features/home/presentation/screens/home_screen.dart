// ignore_for_file: deprecated_member_use

import 'package:brisa_supply_chain/features/home/data/repositories/tflite_services.dart';
import 'package:brisa_supply_chain/features/home/presentation/screens/prediction_screen.dart';
import 'package:brisa_supply_chain/features/home/presentation/widgets/bottom_nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math'; // 🟢 IMPORTED FOR RANDOM CHART DATA GENERATION

// --- Models (Updated PriceData to use double for calculation) ---

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
  final double rawPrice; // 🟢 NEW: Use double for calculation/charting
  final double change;

  // Use rawPrice to create the display price string
  String get price => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  ).format(rawPrice).replaceAll(',', '.'); // Format on-the-fly

  PriceData({required this.name, required this.rawPrice, required this.change});
}

// 🟢 CHART DATA MODEL
class ChartData {
  final String month;
  final double price;

  ChartData(this.month, this.price);
}

// CommodityData HARUS DIIMPOR DARI TFLITE_SERVICES
// atau didefinisikan di sini jika tidak bisa diimpor.
// Asumsi sudah diimpor.

// --- Main Screen Widget ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // ... (IndexData remains the same)
  static final List<IndexData> indexData = [
    IndexData(
      title: 'IHK',
      value: 108.57,
      change: 0.046,
      changeColor: Colors.green,
    ),
    // ... (other IndexData)
    IndexData(
      title: 'IHKP',
      value: 122.69,
      change: 0.097,
      changeColor: Colors.green,
    ),
  ];

  // 🟢 UPDATED: price field is now rawPrice (double)
  static final List<PriceData> priceData = [
    PriceData(name: 'Beras Premium', rawPrice: 16095.0, change: -0.86),
    PriceData(name: 'Beras Medium', rawPrice: 13997.0, change: -0.59),
    PriceData(name: 'Bawang Merah', rawPrice: 46868.0, change: -2.58),
    PriceData(name: 'Bawang Putih', rawPrice: 37558.0, change: -1.49),
    PriceData(name: 'Cabai Merah Keriting', rawPrice: 40532.0, change: -0.67),
    PriceData(name: 'Cabai Merah Besar', rawPrice: 40998.0, change: -1.45),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TfliteServices _tfliteService = TfliteServices();

  // 🟢 STATE BARU UNTUK HARGA CSV
  String _csvPriceResult = 'Memuat harga Beras Super I (CSV)...';

  // CommodityData? _berasSuper1Data; // Tidak perlu disimpan sebagai state, cukup String result

  @override
  void initState() {
    super.initState();
    // Panggil kedua inisialisasi
    _tfliteService.loadModel();
    _loadBerasCsvPrice(); // 🟢 Panggil fungsi pemuatan harga CSV
  }

  // 🟢 FUNGSI BARU UNTUK MEMUAT HARGA CSV
  void _loadBerasCsvPrice() {
    // Panggil fungsi getBerasKualitasSuper1() dari service lo
    final berasData = _tfliteService.getBerasKualitasSuper1();

    setState(() {
      if (berasData != null) {
        // Ambil harga dan format ke 2 desimal
        final formattedPrice = _formatPrice(berasData.predNextMonthPrice);
        _csvPriceResult =
            'Prediksi CSV Beras Kualitas Super I (Cluster ${berasData.cluster}): $formattedPrice';
      } else {
        _csvPriceResult = 'Data Beras Kualitas Super I tidak ditemukan di CSV.';
      }
    });
  }

  final List<double> dummyInput = [
    0.1,
    0.5,
    0.3,
    0.8,
    0.2,
  ]; // Sesuai jumlah fitur model lo!

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 2, // Nilai 2 untuk memastikan 2 angka di belakang koma
    );
    return formatter.format(price);
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
              // 1. User/Greeting Section
              const _UserGreeting(),
              const SizedBox(height: 16),

              // 2. Index Cards Section
              _IndexCardRow(data: HomeScreen.indexData),
              const SizedBox(height: 24),

              // 3. Trending Section (Text + Chips)
              const _TrendingSection(),
              const SizedBox(height: 24),

              // 4. Harga Terkini Header
              Text(
                'Harga & Prediksi 📈',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                icon: const Icon(Icons.analytics_outlined, size: 20),
                label: const Text('Jalankan Prediksi TFLite'),
                style: ElevatedButton.styleFrom(
                  // Ganti dari biru ke ungu
                  backgroundColor: Colors.purple.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PredictionScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // 6. Price Cards Grid
              _PriceGrid(priceData: HomeScreen.priceData),
            ],
          ),
        ),
      ),
      // 7. Bottom Navigation Bar (Simplified)
      bottomNavigationBar: const BottomNavWidget(currentIndex: 0),
    );
  }
}

// ... (Component Widgets seperti _UserGreeting, _IndexCard, _PriceCard, dll. tetap sama)

// --- Component Widgets ---

/// 1. User/Greeting Section
class _UserGreeting extends StatelessWidget {
  const _UserGreeting();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Picture Placeholder
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/profile_image.png',
              ), // Replace with actual asset
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hello Yuhaaa ~',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'Selamat datang, Yuhaaa 🤝',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

/// 2. Reusable Index Card Widget
class _IndexCard extends StatelessWidget {
  final IndexData data;

  const _IndexCard({required this.data});

  @override
  Widget build(BuildContext context) {
    // The main color of the card is a very light purple
    const Color cardColor = Color(0xFFF3EDF5);
    final isPositive = data.change > 0;
    final changeIcon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
    final changeColor =
        isPositive ? Colors.green.shade600 : Colors.red.shade600;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.value.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(changeIcon, size: 14, color: changeColor),
                const SizedBox(width: 4),
                Text(
                  '${data.change.abs().toStringAsFixed(3)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: changeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Index Card Row Layout
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

/// 3. Trending Section
class _TrendingSection extends StatelessWidget {
  const _TrendingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trending 🔥',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _TrendingChip(text: 'Apa update harga sembako hari ini??'),
              const SizedBox(width: 8),
              _TrendingChip(text: 'Apa peluang usaha hari'),
              const SizedBox(width: 8),
              _TrendingChip(text: 'Trending lainnya...'), // Add more chips
            ],
          ),
        ),
      ],
    );
  }
}

/// Trending Chip Widget
class _TrendingChip extends StatelessWidget {
  final String text;

  const _TrendingChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EDF5), // Light background color for the chip
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}

// ... (Your imports and models remain the same, ensure PriceData has rawPrice: double) ...
// The ChartData model also remains the same
// The _generateRandomChartData function (for the full modal) remains the same

// --- Price Card Reusable Widget (Updated with Mini-Chart Preview) ---
class _PriceCard extends StatelessWidget {
  final PriceData data;

  const _PriceCard({required this.data});

  // Helper for Price Formatting

  // Function to generate random data for the FULL modal chart (already exists)
  List<ChartData> _generateRandomChartData(double basePrice) {
    final Random random = Random();
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
    ];
    final List<ChartData> chartData = [];
    double currentPrice = basePrice * 0.95;

    for (int i = 0; i < months.length; i++) {
      double fluctuation = basePrice * 0.05 * (random.nextDouble() * 2 - 1);
      currentPrice = (currentPrice + fluctuation).clamp(
        basePrice * 0.85,
        basePrice * 1.15,
      );

      if (i > 0) {
        currentPrice = (currentPrice * 0.7) + (chartData.last.price * 0.3);
      }

      chartData.add(ChartData(months[i], currentPrice));
    }
    return chartData;
  }

  // 🟢 NEW: Function to generate very simplified data for the MINI chart
  List<ChartData> _generateMiniChartData(double basePrice) {
    final Random random = Random(
      basePrice.toInt(),
    ); // Use basePrice as seed for consistent random
    final List<ChartData> miniData = [];
    double currentPrice =
        basePrice *
        (1.0 + (random.nextDouble() - 0.5) * 0.1); // Initial fluctuation

    // Generate 4 data points for a simple trend
    for (int i = 0; i < 4; i++) {
      miniData.add(ChartData('M${i + 1}', currentPrice));
      currentPrice +=
          (random.nextDouble() - 0.5) *
          (basePrice * 0.03); // Small random change
      currentPrice = currentPrice.clamp(
        basePrice * 0.9,
        basePrice * 1.1,
      ); // Keep it close to base
    }
    return miniData;
  }

  // Function to show the modal bottom sheet (remains the same)
  void _showPriceHistory(BuildContext context) {
    final List<ChartData> chartData = _generateRandomChartData(data.rawPrice);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return _buildPriceHistoryModal(context, data, chartData);
      },
    );
  }

  // Modal Content Widget (remains the same as previous response)
  Widget _buildPriceHistoryModal(
    BuildContext context,
    PriceData data,
    List<ChartData> chartData,
  ) {
    final isPositive = data.change > 0;
    final changeColor =
        isPositive ? Colors.green.shade600 : Colors.red.shade600;

    double maxPrice = chartData.map((e) => e.price).reduce(max) * 1.05;
    double minPrice = chartData.map((e) => e.price).reduce(min) * 0.95;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          Container(
            height: 5,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harga ${data.name} Hari Ini',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      data.price,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: changeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${data.change.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: changeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: _buildChartPlaceholder(chartData, minPrice, maxPrice),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Detail perubahan harga per bulan (Data acak untuk simulasi).',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // Chart Placeholder Widget (Same as previous response, for the MODAL)
  Widget _buildChartPlaceholder(
    List<ChartData> data,
    double minPrice,
    double maxPrice,
  ) {
    final List<String> xLabels = data.map((d) => d.month).toList();
    final priceRange = (maxPrice - minPrice);
    final yLabels = [
      (minPrice).toInt(),
      (minPrice + priceRange * 0.33).toInt(),
      (minPrice + priceRange * 0.66).toInt(),
      (maxPrice).toInt(),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Y-Axis Labels
          Positioned(
            left: 0,
            top: 0,
            bottom: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children:
                  yLabels.reversed
                      .map(
                        (price) => Text(
                          NumberFormat.compact().format(price),
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      )
                      .toList(),
            ),
          ),
          // X-Axis Labels
          Positioned(
            left: 40,
            right: 10,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  xLabels
                      .map(
                        (month) => Text(
                          month,
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      )
                      .toList(),
            ),
          ),
          // Chart Drawing Area
          Positioned.fill(
            left: 40,
            right: 10,
            top: 10,
            bottom: 20,
            child: CustomPaint(
              painter: _ChartPainter(data, minPrice, maxPrice),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Build Method (Now with Mini-Chart) ---
  @override
  Widget build(BuildContext context) {
    final isPositive = data.change > 0;
    final changeIcon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
    final changeColor =
        isPositive ? Colors.green.shade600 : Colors.red.shade600;

    // 🟢 Generate mini chart data here
    final List<ChartData> miniChartData = _generateMiniChartData(data.rawPrice);
    double miniMaxPrice = miniChartData.map((e) => e.price).reduce(max) * 1.05;
    double miniMinPrice = miniChartData.map((e) => e.price).reduce(min) * 0.95;

    return InkWell(
      onTap: () => _showPriceHistory(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              data.price,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${data.change.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 14,
                    color: changeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(changeIcon, size: 14, color: changeColor),
              ],
            ),
            const SizedBox(height: 8),
            // 🟢 Mini Chart Preview Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  // Background gradient for the mini chart
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade100.withOpacity(0.5),
                      Colors.purple.shade50.withOpacity(0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 8.0,
                  ),
                  child: CustomPaint(
                    // 🟢 Use a new painter for the mini chart to simplify it
                    painter: _MiniChartPainter(
                      miniChartData,
                      miniMinPrice,
                      miniMaxPrice,
                      Colors.purple,
                    ),
                    child: Center(),
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

// 🟢 NEW: Custom Painter for drawing the MINI chart (Simplified)
class _MiniChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double minPrice;
  final double maxPrice;
  final Color lineColor; // Color based on positive/negative change

  _MiniChartPainter(this.data, this.minPrice, this.maxPrice, this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return; // Need at least 2 points to draw a line

    final Paint linePaint =
        Paint()
          ..color =
              lineColor // Slightly lighter line color
          ..strokeWidth =
              1.5 // Thinner line for mini chart
          ..style = PaintingStyle.stroke;

    final Paint fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lineColor.withOpacity(0.3), // Lighter fill
              lineColor.withOpacity(0.05),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path path = Path();
    final double stepX = size.width / (data.length - 1);
    final double priceRange = maxPrice - minPrice;

    // Start path at the first data point
    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      final double normalizedPrice = (data[i].price - minPrice) / priceRange;
      final double y = size.height * (1.0 - normalizedPrice); // Invert Y-axis

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Create area path
    final Path areaPath = Path.from(path);
    areaPath.lineTo(size.width, size.height); // Bottom right
    areaPath.lineTo(0, size.height); // Bottom left
    areaPath.close();

    canvas.drawPath(areaPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _MiniChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.lineColor != lineColor;
  }
}

// _ChartPainter (for the MODAL, remains the same as previous response)
class _ChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double minPrice;
  final double maxPrice;

  _ChartPainter(this.data, this.minPrice, this.maxPrice);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final Paint linePaint =
        Paint()
          ..color = Colors.purple.shade500
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    final Paint fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade300.withOpacity(0.5),
              Colors.purple.shade50.withOpacity(0.1),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path path = Path();
    final double stepX = size.width / (data.length - 1);
    final double priceRange = maxPrice - minPrice;

    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      final double normalizedPrice = (data[i].price - minPrice) / priceRange;
      final double y = size.height * (1.0 - normalizedPrice);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final Path areaPath = Path.from(path);
    areaPath.lineTo(size.width, size.height);
    areaPath.lineTo(0, size.height);
    areaPath.close();

    canvas.drawPath(areaPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Price Grid Layout
class _PriceGrid extends StatelessWidget {
  final List<PriceData> priceData;

  const _PriceGrid({required this.priceData});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true, // Important for nested scroll views
      physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
      itemCount: priceData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio:
            0.85, // Adjust to control card height relative to width
      ),
      itemBuilder: (context, index) {
        return _PriceCard(data: priceData[index]);
      },
    );
  }
}

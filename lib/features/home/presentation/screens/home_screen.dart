// home_screen.dart

import 'package:flutter/material.dart';

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

class HomeScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The app bar shows the time and status icons (Simulated)
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
              _IndexCardRow(data: indexData),
              const SizedBox(height: 24),

              // 3. Trending Section (Text + Chips)
              const _TrendingSection(),
              const SizedBox(height: 24),

              // 4. Harga Terkini Header
              const Text(
                'Harga Terkini 💳',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // 5. Price Cards Grid
              _PriceGrid(priceData: priceData),
            ],
          ),
        ),
      ),
      // 6. Bottom Navigation Bar (Simplified)
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

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
            borderRadius: BorderRadius.circular(100),
            // image: const DecorationImage(
            //   image: AssetImage(
            //     'assets/placeholder_profile.png',
            //   ), // Replace with actual asset
            //   fit: BoxFit.cover,
            // ),
          ),
          child: const Icon(Icons.person, color: Colors.purple),
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

/// 4. Price Card Reusable Widget
class _PriceCard extends StatelessWidget {
  final PriceData data;

  const _PriceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isPositive = data.change > 0;
    final changeIcon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
    final changeColor =
        isPositive ? Colors.green.shade600 : Colors.red.shade600;

    return Container(
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
          // Simplified graph placeholder using a Container and gradient
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade100.withOpacity(0.5),
                    Colors.purple.shade50.withOpacity(0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              // In a real app, this would be a custom painter or a chart library widget (e.g., fl_chart)
              child: const Center(
                child: Text(
                  'Chart Placeholder',
                  style: TextStyle(fontSize: 10, color: Colors.purple),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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

/// 5. Simplified Bottom Navigation Bar
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        currentIndex: 0,
        selectedItemColor: const Color(0xFF673AB7), // Purple for selected item
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

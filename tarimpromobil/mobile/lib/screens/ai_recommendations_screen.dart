import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AiRecommendationsScreen extends StatelessWidget {
  const AiRecommendationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int score = 85;

    final recommendations = [
      {
        'crop': 'Mısır',
        'expectedReturn': '%18 Artış',
        'reason': 'Bölgenizde yağışlar bu yıl %15 daha fazla bekleniyor, mısır ekimi daha kârlı olabilir.',
        'icon': Icons.grass,
        'color': Colors.amber,
      },
      {
        'crop': 'Soya Fasulyesi',
        'expectedReturn': '%14 Artış',
        'reason': 'Toprak yapınız ve güncel piyasa talebi soya fasulyesi için oldukça uygun.',
        'icon': Icons.trending_up,
        'color': Colors.blue,
      },
      {
        'crop': 'Kanola',
        'expectedReturn': '%11 Artış',
        'reason': 'Alternatif yağlı tohum olarak düşük su tüketimi ile avantajlı bir seçenek.',
        'icon': Icons.check_circle_outline,
        'color': Colors.green,
      }
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Yapay Zeka Sonuçları'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yapay Zeka Analiz Sonuçları',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tarlanız için en uygun strateji başarı oranı',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            // Top Section - Gauge Chart mock
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: [
                                PieChartSectionData(
                                  value: score.toDouble(),
                                  color: Colors.green,
                                  title: '',
                                  radius: 12,
                                ),
                                PieChartSectionData(
                                  value: (100 - score).toDouble(),
                                  color: Colors.grey[300]!,
                                  title: '',
                                  radius: 12,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('%$score', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              const Text('Başarı', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Seçtiğiniz Plana Onay Skoru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          Text(
                            'Mevcut iklim, toprak ve piyasa verilerine göre ekimi için başarı beklentisi oldukça yüksek.',
                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Left Column - Recommendations
            const Text(
              'Modelin Alternatif Önerileri',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...recommendations.map((item) {
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['crop'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item['expectedReturn'] as String,
                                    style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('Neden bu ürün?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(item['reason'] as String, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 24),

            // Right Column - LineChart trend
            const Text(
              'Piyasa Üretim/Tüketim Trendi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0, left: 16.0, top: 24.0, bottom: 16.0),
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true, 
                        drawVerticalLine: false, 
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 1, dashArray: [5, 5])
                      ),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              const years = ['2019', '2020', '2021', '2022', '2023', '2024', '2025'];
                              int index = value.toInt();
                              if (index >= 0 && index < years.length) {
                                return SideTitleWidget(meta: meta, child: Text(years[index], style: const TextStyle(fontSize: 10)));
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 20,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              if (value < 100) return const SizedBox();
                              return SideTitleWidget(meta: meta, child: Text('${value.toInt()}', style: const TextStyle(fontSize: 10)));
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 6,
                      minY: 100,
                      maxY: 180,
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 120), FlSpot(1, 130), FlSpot(2, 115), 
                            FlSpot(3, 140), FlSpot(4, 155), FlSpot(5, 145), FlSpot(6, 165),
                          ],
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 110), FlSpot(1, 125), FlSpot(2, 135), 
                            FlSpot(3, 145), FlSpot(4, 150), FlSpot(5, 160), FlSpot(6, 170),
                          ],
                          isCurved: true,
                          color: Colors.orange,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [Container(width: 12, height: 12, color: Colors.green), const SizedBox(width: 4), const Text('Üretim')]),
                const SizedBox(width: 24),
                Row(children: [Container(width: 12, height: 12, color: Colors.orange), const SizedBox(width: 4), const Text('Tüketim')]),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ClimateMarketScreen extends StatefulWidget {
  const ClimateMarketScreen({Key? key}) : super(key: key);

  @override
  _ClimateMarketScreenState createState() => _ClimateMarketScreenState();
}

class _ClimateMarketScreenState extends State<ClimateMarketScreen> {
  String _period = '1Y';

  final List<Map<String, dynamic>> _climateData = [
    {'month': 'Oca', 'rainfall': 65, 'temp': 4, 'droughtRisk': 10},
    {'month': 'Şub', 'rainfall': 55, 'temp': 6, 'droughtRisk': 15},
    {'month': 'Mar', 'rainfall': 50, 'temp': 9, 'droughtRisk': 20},
    {'month': 'Nis', 'rainfall': 40, 'temp': 14, 'droughtRisk': 35},
    {'month': 'May', 'rainfall': 30, 'temp': 19, 'droughtRisk': 50},
    {'month': 'Haz', 'rainfall': 20, 'temp': 24, 'droughtRisk': 75},
    {'month': 'Tem', 'rainfall': 10, 'temp': 28, 'droughtRisk': 90},
    {'month': 'Ağu', 'rainfall': 15, 'temp': 27, 'droughtRisk': 85},
    {'month': 'Eyl', 'rainfall': 25, 'temp': 22, 'droughtRisk': 60},
    {'month': 'Eki', 'rainfall': 45, 'temp': 16, 'droughtRisk': 30},
    {'month': 'Kas', 'rainfall': 60, 'temp': 10, 'droughtRisk': 15},
    {'month': 'Ara', 'rainfall': 70, 'temp': 6, 'droughtRisk': 5},
  ];

  Color _getRiskColor(int risk) {
    if (risk < 30) return Colors.green[400]!; // Safe Green
    if (risk < 60) return Colors.orange[400]!; // Warning Yellow/Orange
    return Colors.red[400]!; // Danger Red
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('İklim ve Piyasa'),
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
              'İklim ve Pazar Verileri',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bölgesel makro veriler ve yapay zeka analizleri',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),

            // Period Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.grey),
                  const SizedBox(width: 8),
                  _buildFilterBtn('6M', 'Gelecek 6 Ay'),
                  const SizedBox(width: 8),
                  _buildFilterBtn('1Y', 'Son 1 Yıl'),
                  const SizedBox(width: 8),
                  _buildFilterBtn('5Y', 'Son 5 Yıl'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Rainfall Bar Chart
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.water_drop, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Aylık Ortalama Yağış Miktarı (mm)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 80,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  if (value.toInt() < 0 || value.toInt() >= _climateData.length) return const SizedBox();
                                  return SideTitleWidget(
                                    meta: meta,
                                    child: Text(_climateData[value.toInt()]['month'], style: const TextStyle(fontSize: 10)),
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 20,
                            getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[200], strokeWidth: 1),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: _climateData.asMap().entries.map((entry) {
                            int index = entry.key;
                            var data = entry.value;
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: data['rainfall'].toDouble(),
                                  color: Colors.blue[300],
                                  width: 16,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Temperature & Drought Risk Heatmap
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.thermostat, color: Colors.red[600]),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Sıcaklık ve Kuraklık Riski Isı Haritası', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 40,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  if (value.toInt() < 0 || value.toInt() >= _climateData.length) return const SizedBox();
                                  return SideTitleWidget(
                                    meta: meta,
                                    child: Text(_climateData[value.toInt()]['month'], style: const TextStyle(fontSize: 10)),
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 10,
                            getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[200], strokeWidth: 1),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: _climateData.asMap().entries.map((entry) {
                            int index = entry.key;
                            var data = entry.value;
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: data['temp'].toDouble(),
                                  color: _getRiskColor(data['droughtRisk']),
                                  width: 16,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem(Colors.green[400]!, 'Düşük'),
                        const SizedBox(width: 12),
                        _buildLegendItem(Colors.orange[400]!, 'Orta'),
                        const SizedBox(width: 12),
                        _buildLegendItem(Colors.red[400]!, 'Yüksek (Kuraklık)'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // AI Insights
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.blue[50], // slight tint
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.psychology, color: Colors.blue[900], size: 28),
                        const SizedBox(width: 8),
                        Text('Yapay Zeka Yorumu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[900])),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Veriler incelendiğinde yaz aylarında (Haziran - Ağustos) şiddetli bir kuraklık riski tespit edilmiştir.',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    _buildInsightPoint('Yağış Rejimi:', 'Geçen yıla oranla bahar yağışlarında %15 azalma var. Erken ekim stratejileri tercih edilmeli.'),
                    _buildInsightPoint('Sıcaklık Stresi:', 'Temmuz ayında ortalama sıcaklıkların ekstrem seviyelere (28°C+) ulaşması bekleniyor. Su stresine dayanıklı tohum tipleri kullanılmalı.'),
                    _buildInsightPoint('Pazar Yorumu:', 'Kuraklık beklentisi sebebiyle mısır ve pamuk gibi çok su tüketen ürünlerde arz sıkıntısı yaşanabilir, bu durum hasat sonu piyasa fiyatlarını %20 oranında yukarı çekebilir.'),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('Son Güncelleme: TÜİK & MGM Verileri (Bugün 09:00)', style: TextStyle(color: Colors.grey[600], fontSize: 11, fontStyle: FontStyle.italic)),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBtn(String id, String label) {
    bool isSelected = _period == id;
    return InkWell(
      onTap: () {
        setState(() {
          _period = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.green : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildInsightPoint(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.grey[800], fontSize: 13, height: 1.4),
                children: [
                  TextSpan(text: '\$title ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

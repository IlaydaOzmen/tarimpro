import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _userName = '';
  Map<String, dynamic>? _summaryData;
  List<dynamic> _alerts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('userName') ?? 'Kullanıcı';

      final summaryResponse = await http.get(Uri.parse('http://10.0.2.2:8001/api/dashboard/summary'));
      final alertsResponse = await http.get(Uri.parse('http://10.0.2.2:8001/api/dashboard/alerts'));

      if (summaryResponse.statusCode == 200 && alertsResponse.statusCode == 200) {
        setState(() {
          _summaryData = json.decode(utf8.decode(summaryResponse.bodyBytes));
          _alerts = json.decode(utf8.decode(alertsResponse.bodyBytes));
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Veri çekme hatası: ${summaryResponse.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Bağlantı hatası: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Widget _buildSummaryCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Icon(icon, color: color),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlert(Map<String, dynamic> alert) {
    MaterialColor alertColor = alert['type'] == 'danger' ? Colors.red : Colors.orange;
    IconData alertIcon = alert['type'] == 'danger' ? Icons.error : Icons.warning;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: alertColor.withOpacity(0.1),
        border: Border.all(color: alertColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(alertIcon, color: alertColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              alert['message'],
              style: TextStyle(color: alertColor[900]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hoş geldin, $_userName',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'İşte çiftliğinin bugünkü özeti',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Summary Grid
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          children: [
                            _buildSummaryCard(
                              'Hava Durumu',
                              _summaryData?['weather']?['temp'] ?? '-',
                              _summaryData?['weather']?['condition'] ?? '-',
                              Icons.wb_sunny,
                              Colors.orange,
                            ),
                            _buildSummaryCard(
                              'Toprak Nemi',
                              _summaryData?['soilMoisture']?['level'] ?? '-',
                              _summaryData?['soilMoisture']?['status'] ?? '-',
                              Icons.water_drop,
                              Colors.blue,
                            ),
                            _buildSummaryCard(
                              'Piyasa Trendi',
                              _summaryData?['marketTrend']?['status'] ?? '-',
                              _summaryData?['marketTrend']?['indicator'] ?? '-',
                              Icons.trending_up,
                              Colors.green,
                            ),
                            _buildSummaryCard(
                              'Sonraki Hasat',
                              '7 Gün',
                              '2024 Buğday',
                              Icons.calendar_month,
                              Colors.purple,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        Text(
                          'Önemli Uyarılar',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._alerts.map((alert) => _buildAlert(alert as Map<String, dynamic>)).toList(),
                      ],
                    ),
                  ),
                ),
    );
  }
}

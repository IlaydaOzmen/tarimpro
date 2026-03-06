import 'package:flutter/material.dart';

class PlanWizardScreen extends StatefulWidget {
  const PlanWizardScreen({Key? key}) : super(key: key);

  @override
  _PlanWizardScreenState createState() => _PlanWizardScreenState();
}

class _PlanWizardScreenState extends State<PlanWizardScreen> {
  String? _selectedRegion;
  final TextEditingController _sizeController = TextEditingController();
  String? _selectedCrop;
  bool _isAnalyzing = false;

  final List<Map<String, dynamic>> _crops = [
    {'id': 'wheat', 'name': 'Buğday', 'icon': Icons.eco},
    {'id': 'sunflower', 'name': 'Ayçiçeği', 'icon': Icons.wb_sunny},
    {'id': 'cotton', 'name': 'Pamuk', 'icon': Icons.water_drop},
    {'id': 'corn', 'name': 'Mısır', 'icon': Icons.grass},
  ];

  void _handleAnalyze() {
    if (_selectedRegion == null || _sizeController.text.isEmpty || _selectedCrop == null) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI processing delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analiz tamamlandı. Yapay Zeka ekranına yönlendiriliyorsunuz (Mock)'),
            backgroundColor: Colors.green,
          ),
        );
        // In the future this should switch BottomNavigationBar index to 2 
        // passing state if possible, or using a state manager.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid = _selectedRegion != null && _sizeController.text.isNotEmpty && _selectedCrop != null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Plan Sihirbazı'),
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
              'Yeni Üretim Planı Oluştur',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tarlanızın verileriyle en doğru kararı verin',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            // Step 1: Location
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
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.green[100],
                          child: Text('1', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        const Text('Tarlanız Hangi Bölgede?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedRegion,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      hint: const Text('İl veya Bölge Seçiniz...'),
                      items: const [
                        DropdownMenuItem(value: 'marmara', child: Text('Marmara Bölgesi (Balıkesir, Bursa...)')),
                        DropdownMenuItem(value: 'ic_anadolu', child: Text('İç Anadolu Bölgesi (Konya, Ankara...)')),
                        DropdownMenuItem(value: 'ege', child: Text('Ege Bölgesi (İzmir, Manisa...)')),
                        DropdownMenuItem(value: 'akdeniz', child: Text('Akdeniz Bölgesi (Adana, Mersin...)')),
                        DropdownMenuItem(value: 'guneydogu', child: Text('Güneydoğu Anadolu (Şanlıurfa, Gaziantep...)')),
                      ],
                      onChanged: (value) => setState(() => _selectedRegion = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step 2: Size
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
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.green[100],
                          child: Text('2', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        const Text('Tarla Büyüklüğünüz', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _sizeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.square_foot, color: Colors.grey),
                        suffixText: 'Dönüm',
                        hintText: 'Örn: 150',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step 3: Crop Selection
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
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.green[100],
                          child: Text('3', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        const Text('Düşündüğünüz Ürün (Opsiyonel)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _crops.length,
                      itemBuilder: (context, index) {
                        final crop = _crops[index];
                        final isSelected = _selectedCrop == crop['id'];
                        return InkWell(
                          onTap: () => setState(() => _selectedCrop = crop['id']),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.green[50] : Colors.white,
                              border: Border.all(
                                color: isSelected ? Colors.green : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(crop['icon'], color: isSelected ? Colors.green : Colors.grey[600]),
                                const SizedBox(width: 8),
                                Text(
                                  crop['name'],
                                  style: TextStyle(
                                    color: isSelected ? Colors.green[800] : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: isFormValid && !_isAnalyzing ? _handleAnalyze : null,
                icon: _isAnalyzing 
                  ? const SizedBox(
                      width: 24, 
                      height: 24, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    )
                  : const Icon(Icons.auto_awesome),
                label: Text(
                  _isAnalyzing ? 'Yapay Zeka Analiz Ediyor...' : 'Yapay Zeka ile Analiz Et',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid ? Colors.green : Colors.grey[400],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            if (!isFormValid)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Center(
                  child: Text(
                    'Lütfen analiz için tüm alanları doldurun.',
                    style: TextStyle(color: Colors.red[400], fontSize: 14),
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

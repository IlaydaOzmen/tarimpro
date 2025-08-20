import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/hasta_controller.dart';
import '../controller/doktor_controller.dart';

class HastaRandevuPage extends StatelessWidget {
  final Map<String, dynamic> hasta;

  HastaRandevuPage({super.key, required this.hasta});

  final HastaController hastaController = Get.find();
  final DoktorController doktorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoşgeldiniz ${hasta['adSoyad']}'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          'Kişisel Bilgileriniz',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    _buildInfoRow('Ad Soyad', hasta['adSoyad']),
                    _buildInfoRow('TC', hasta['tc']),
                    _buildInfoRow('Doğum Tarihi', hasta['dogumTarihi']),
                    _buildInfoRow('Cinsiyet', hasta['cinsiyet']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showRandevuDialog(context);
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Randevu Al', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showRandevularimDialog(context);
                },
                icon: const Icon(Icons.list),
                label: const Text(
                  'Randevularım',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }

  Future<void> _showRandevuDialog(BuildContext context) async {
    await doktorController.doktorlariYukle(); // Doktorları yükle ve bekle

    hastaController.selectedPoliklinik.value = '';
    hastaController.selectedDoktor.value = '';
    hastaController.selectedTarih.value = '';
    hastaController.selectedSaat.value = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.teal),
            const SizedBox(width: 8),
            const Text('Randevu Al'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Poliklinik Seçimi
                Obx(
                  () => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Poliklinik Seçin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_hospital),
                    ),
                    value: hastaController.selectedPoliklinik.value.isEmpty
                        ? null
                        : hastaController.selectedPoliklinik.value,
                    items: hastaController.poliklinikler
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) {
                      hastaController.selectedPoliklinik.value = val ?? '';
                      hastaController.selectedDoktor.value = '';
                      hastaController.selectedTarih.value = '';
                      hastaController.selectedSaat.value = '';
                      doktorController.poliklinikDoktorlari(val ?? '');
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Doktor Seçimi
                Obx(
                  () => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Doktor Seçin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    value: hastaController.selectedDoktor.value.isEmpty
                        ? null
                        : hastaController.selectedDoktor.value,
                    items: doktorController.filtrelenmisDoktorlar
                        .map(
                          (d) => DropdownMenuItem(
                            value: d['id'].toString(),
                            child: Text(d['adSoyad']),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      hastaController.selectedDoktor.value = val ?? '';
                      hastaController.selectedTarih.value = '';
                      hastaController.selectedSaat.value = '';
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Tarih Seçimi
                Obx(
                  () => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tarih Seçin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.date_range),
                    ),
                    value: hastaController.selectedTarih.value.isEmpty
                        ? null
                        : hastaController.selectedTarih.value,
                    items: hastaController.uygunTarihler
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) {
                      hastaController.selectedTarih.value = val ?? '';
                      hastaController.selectedSaat.value = '';
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Saat Seçimi
                FutureBuilder<List<String>>(
                  future: hastaController.getUygunSaatler(),
                  builder: (context, snapshot) {
                    final saatler = snapshot.data ?? [];
                    final benzersizSaatler = saatler.toSet().toList();

                    return Obx(
                      () => DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Saat Seçin',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        value:
                            benzersizSaatler.contains(
                              hastaController.selectedSaat.value,
                            )
                            ? hastaController.selectedSaat.value
                            : null,
                        items: benzersizSaatler
                            .map(
                              (saat) => DropdownMenuItem<String>(
                                value: saat,
                                child: Text(saat),
                              ),
                            )
                            .toList(),
                        onChanged: (seciliSaat) {
                          hastaController.selectedSaat.value = seciliSaat ?? '';
                        },
                        hint: saatler.isEmpty
                            ? const Text('Bu tarihte uygun saat yok')
                            : const Text('Saat seçiniz'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              hastaController.randevuAl(hasta);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Randevu Al'),
          ),
        ],
      ),
    );
  }

  void _showRandevularimDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.list, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('Randevularım'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: hastaController.hastaRandevulari(hasta['tc']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final randevular = snapshot.data ?? [];

              if (randevular.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Henüz randevunuz bulunmuyor.'),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: randevular.length,
                itemBuilder: (context, index) {
                  final randevu = randevular[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        randevu['doktorAd'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📋 ${randevu['poliklinik']}'),
                          Text('🗓 ${randevu['tarih']} - ⏰ ${randevu['saat']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'Randevu İptali',
                            middleText:
                                'Bu randevuyu iptal etmek istediğinizden emin misiniz?',
                            textCancel: 'Hayır',
                            textConfirm: 'Evet, İptal Et',
                            confirmTextColor: Colors.white,
                            buttonColor: Colors.red,
                            onConfirm: () {
                              hastaController.randevuIptal(randevu['id']);
                              Get.back();
                              Navigator.pop(context);
                              _showRandevularimDialog(context);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }
}
